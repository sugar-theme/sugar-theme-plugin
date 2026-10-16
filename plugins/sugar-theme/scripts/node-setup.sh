#!/bin/bash
# Installs Node.js (the current LTS) for this user only, so no administrator password
# is ever asked, or says the one already there is current:
#
#   node-setup.sh
#
# The last line it prints is `use=<prefix>`: start every command that needs node, npm,
# npx or shopify with that prefix for the rest of this conversation, since this shell
# started before the install. From the next conversation on it is on the path by itself.
# `use=` with nothing after it means no prefix is needed.
#
# Mac and Linux: nvm, installed with METHOD=script. Without it the installer uses git,
# and on a Mac with no developer tools `git` is a stub that opens Apple's "install
# command line developer tools" dialog. No Homebrew either: its installer asks for the
# user's password in a terminal.
#
# Windows (the Git Bash that Claude Code runs commands in): the official zip from
# nodejs.org unpacked into the user's own folder, then added to their PATH. The Node
# installer (.msi) would ask for administrator rights; nvm doesn't run on Windows.

fail() { echo "$1" >&2; exit 1; }

is_windows() { case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) return 0 ;; esac; return 1; }

# The newest LTS version from nodejs.org's own index, e.g. v24.11.0.
latest_lts() {
  local index
  index="$(curl -fsSL --max-time 20 https://nodejs.org/dist/index.json)" || return 1
  printf '%s\n' "$index" | grep -m1 '"lts":"' | sed -n 's/.*"version":"\(v[0-9.]*\)".*/\1/p'
}

major() { printf '%s' "$1" | sed -n 's/^v\{0,1\}\([0-9]*\).*/\1/p'; }

LTS="$(latest_lts)"
[ -n "$LTS" ] || fail "Couldn't reach nodejs.org to find the current Node.js version."

# Already current: nothing to install.
if command -v node >/dev/null 2>&1; then
  have="$(node --version 2>/dev/null)"
  if [ -n "$have" ] && [ "$(major "$have")" -ge "$(major "$LTS")" ] 2>/dev/null; then
    echo "Node.js $have is already installed and current."
    echo "use="
    exit 0
  fi
fi

if ! is_windows; then
  # A new Mac has no ~/.zshrc, and without one nvm installs but never adds itself to
  # the shell, so every later conversation finds no node. Linux shells read ~/.bashrc.
  touch ~/.zshrc ~/.bashrc
  curl -fsSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | METHOD=script bash ||
    fail "Installing nvm failed."
  # shellcheck disable=SC1090
  . ~/.nvm/nvm.sh && nvm install --lts >/dev/null && nvm alias default 'lts/*' >/dev/null ||
    fail "nvm couldn't install Node.js."
  echo "Installed Node.js $(node --version)."
  echo "use=. ~/.nvm/nvm.sh &&"
  exit 0
fi

# --- Windows ---------------------------------------------------------------------------

command -v cygpath >/dev/null 2>&1 || fail "This needs Git Bash (Git for Windows), which Claude Code uses for commands."
case "${PROCESSOR_ARCHITEW6432:-$PROCESSOR_ARCHITECTURE}" in
  ARM64) arch=arm64 ;;
  *) arch=x64 ;;
esac
[ -n "$LOCALAPPDATA" ] || fail "LOCALAPPDATA is not set, so there is no per-user folder to install into."

DEST="$(cygpath -u "$LOCALAPPDATA")/Programs/nodejs"
NAME="node-$LTS-win-$arch"
tmp="$(mktemp -d)" || exit 1
trap 'rm -rf "$tmp"' EXIT

echo "Downloading Node.js $LTS ($arch)..."
curl -fL --progress-bar -o "$tmp/node.zip" "https://nodejs.org/dist/$LTS/$NAME.zip" ||
  fail "Downloading Node.js failed."

# Git Bash may lack unzip; Windows 10 and later ship tar.exe, which reads zips, and
# PowerShell is the last resort.
if command -v unzip >/dev/null 2>&1; then
  unzip -q "$tmp/node.zip" -d "$tmp"
elif [ -x "$(cygpath -u "${SYSTEMROOT:-C:\\Windows}")/System32/tar.exe" ]; then
  "$(cygpath -u "${SYSTEMROOT:-C:\\Windows}")/System32/tar.exe" -xf "$(cygpath -w "$tmp/node.zip")" -C "$(cygpath -w "$tmp")"
else
  powershell.exe -NoProfile -NonInteractive -Command \
    "Expand-Archive -LiteralPath '$(cygpath -w "$tmp/node.zip")' -DestinationPath '$(cygpath -w "$tmp")' -Force"
fi
[ -f "$tmp/$NAME/node.exe" ] || fail "The Node.js download didn't unpack."

# Replacing an older copy fails while something is running from it (another
# conversation's browsers). Say so rather than leave half a folder.
if [ -d "$DEST" ]; then
  rm -rf "$DEST" 2>/dev/null || fail "An older Node.js in $DEST is in use. Close the other Claude conversations and run this again."
fi
mkdir -p "$(dirname "$DEST")" && mv "$tmp/$NAME" "$DEST" || fail "Couldn't move Node.js into $DEST."

# Global packages (the Shopify CLI, sharp, the browser server) go next to node.exe, so
# one folder on the PATH covers all of them.
PATH="$DEST:$PATH" "$DEST/npm" config set prefix "$(cygpath -w "$DEST")" >/dev/null ||
  fail "Couldn't point npm's global folder at $DEST."

# The user's PATH, for every program started from now on (the Claude app picks it up
# when it next starts). Written to the registry as an expandable string so entries
# like %USERPROFILE%\... keep working, then announced to Windows.
WIN_DEST="$(cygpath -w "$DEST")"
powershell.exe -NoProfile -NonInteractive -Command "
  \$k = Get-Item 'HKCU:\\Environment'
  \$p = \$k.GetValue('Path', '', 'DoNotExpandEnvironmentNames')
  if ((';' + \$p + ';') -notlike ('*;' + '$WIN_DEST' + ';*')) {
    \$p = if (\$p) { '$WIN_DEST;' + \$p } else { '$WIN_DEST' }
    Set-ItemProperty -Path 'HKCU:\\Environment' -Name Path -Value \$p -Type ExpandString
    [Environment]::SetEnvironmentVariable('SUGAR_PATH_REFRESH', '1', 'User')
    [Environment]::SetEnvironmentVariable('SUGAR_PATH_REFRESH', \$null, 'User')
  }" || echo "Couldn't add Node.js to the Windows PATH; the Git Bash line below still covers Claude." >&2

# Git Bash reads ~/.bashrc, which is where Claude's commands pick up their PATH until
# the app restarts.
LINE="export PATH=\"$DEST:\$PATH\"  # Sugar Theme: Node.js"
touch ~/.bashrc
grep -qF "# Sugar Theme: Node.js" ~/.bashrc || printf '\n%s\n' "$LINE" >> ~/.bashrc

echo "Installed Node.js $("$DEST/node.exe" --version) in $WIN_DEST."
echo "use=export PATH=\"$DEST:\$PATH\" &&"
