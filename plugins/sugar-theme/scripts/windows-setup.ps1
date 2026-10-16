# Gives Claude on Windows the Git Bash that the plugin's scripts and browsers run in.
#
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File windows-setup.ps1
#
# Prints `bash=<path to bash.exe>` and `restart=yes|no` last. Nothing here asks for an
# administrator password:
#
# 1. Finds a Git Bash already on the computer (Git for Windows in Program Files or the
#    user's own folder, or the git on the PATH). Without one it unpacks Portable Git, the
#    Git for Windows project's own no-install edition, into the user's folder.
# 2. Saves its path as the user's CLAUDE_CODE_GIT_BASH_PATH. Claude Code reads that to
#    find bash, and the plugin's .mcp.json starts the browsers with it; plain `bash` on
#    Windows is either missing or WSL's, which can't run the plugin's scripts.
#
# Programs read new user variables when they start, so `restart=yes` means the Claude
# app has to be quit and opened again before the browsers can start.

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Test-Bash($path) {
  return $path -and (Test-Path -LiteralPath $path -PathType Leaf)
}

$current = [Environment]::GetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', 'User')
$bash = $null
if (Test-Bash $current) { $bash = $current }

if (-not $bash) {
  $candidates = @(
    (Join-Path $env:ProgramFiles 'Git\bin\bash.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Git\bin\bash.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\PortableGit\bin\bash.exe')
  )
  if (${env:ProgramFiles(x86)}) { $candidates += (Join-Path ${env:ProgramFiles(x86)} 'Git\bin\bash.exe') }
  # A git on the PATH lives in <Git>\cmd or <Git>\bin; bash.exe sits in <Git>\bin.
  $git = Get-Command git.exe -ErrorAction SilentlyContinue
  if ($git) { $candidates += (Join-Path (Split-Path (Split-Path $git.Source)) 'bin\bash.exe') }
  foreach ($c in $candidates) {
    if (Test-Bash $c) { $bash = $c; break }
  }
}

if (-not $bash) {
  $arch = if (($env:PROCESSOR_ARCHITEW6432, $env:PROCESSOR_ARCHITECTURE) -contains 'ARM64') { 'arm64' } else { '64-bit' }
  $release = Invoke-RestMethod -UseBasicParsing -Headers @{ 'User-Agent' = 'sugar-theme-plugin' } `
    -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest'
  $asset = $release.assets | Where-Object { $_.name -like "PortableGit-*-$arch.7z.exe" } | Select-Object -First 1
  if (-not $asset) { throw "No Portable Git download for $arch in the latest Git for Windows release." }

  $dest = Join-Path $env:LOCALAPPDATA 'Programs\PortableGit'
  $sfx = Join-Path $env:TEMP $asset.name
  Write-Output "Downloading $($asset.name) ($([math]::Round($asset.size / 1MB)) MB)..."
  Invoke-WebRequest -UseBasicParsing -Uri $asset.browser_download_url -OutFile $sfx
  # A self-extracting archive: -o is where it unpacks, -y answers every prompt.
  $p = Start-Process -FilePath $sfx -ArgumentList @("-o`"$dest`"", '-y') -Wait -PassThru -WindowStyle Hidden
  Remove-Item -LiteralPath $sfx -Force -ErrorAction SilentlyContinue
  if ($p.ExitCode -ne 0) { throw "Unpacking Portable Git failed (exit $($p.ExitCode))." }
  # The step Git Bash would otherwise run the first time a person opens it.
  $post = Join-Path $dest 'post-install.bat'
  if (Test-Path -LiteralPath $post) {
    Start-Process -FilePath (Join-Path $dest 'git-bash.exe') -WorkingDirectory $dest `
      -ArgumentList @('--no-needs-console', '--hide', '--no-cd', '--command=post-install.bat') -Wait -WindowStyle Hidden
  }
  $bash = Join-Path $dest 'bin\bash.exe'
  if (-not (Test-Bash $bash)) { throw "Portable Git unpacked, but $bash is missing." }
  Write-Output "Installed Portable Git in $dest."
}

$restart = 'no'
if ($current -ne $bash) {
  # SetEnvironmentVariable also tells running programs the variables changed.
  [Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', $bash, 'User')
  $restart = 'yes'
}
if ($env:CLAUDE_CODE_GIT_BASH_PATH -ne $bash) { $restart = 'yes' }

Write-Output "bash=$bash"
Write-Output "restart=$restart"
