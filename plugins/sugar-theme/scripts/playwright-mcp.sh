#!/bin/bash
# Starts the Playwright MCP server for the plugin's two headless browsers, and
# runs its browser installs for the setup skill:
#
#   playwright-mcp.sh --headless --browser chromium ...   (from .mcp.json)
#   playwright-mcp.sh install-browser chromium            (from setup)
#
# The version is pinned here, in one place: an unpinned server moves ahead of
# the browsers setup downloaded and then refuses to open them. Raise it together
# with a plugin version bump, and have setup fetch the browsers again.
PLAYWRIGHT_MCP_VERSION="0.0.82"

# Node may be installed where an app-launched process can't see it (nvm edits
# the shell profile, which the app does not read), so look in the usual places.
# The last match wins: the newest nvm version, then Volta, Homebrew, the installer.
if ! command -v npx >/dev/null 2>&1; then
  for dir in /usr/local/bin /opt/homebrew/bin "$HOME/.volta/bin" "$HOME/.nvm/versions/node"/*/bin; do
    if [ -x "$dir/npx" ]; then
      NPX_DIR="$dir"
    fi
  done
  if [ -n "$NPX_DIR" ]; then
    export PATH="$NPX_DIR:$PATH"
  fi
fi

if command -v npx >/dev/null 2>&1; then
  exec npx -y "@playwright/mcp@$PLAYWRIGHT_MCP_VERSION" "$@"
fi

# No Node yet. An install command fails plainly; the server answers as a
# placeholder with one tool that says what to do, so a fresh install does not
# greet the user with a connection error before setup has run.
case "$1" in
  install*)
    echo "Node.js is not installed yet. Install it first (see the setup skill)." >&2
    exit 1
    ;;
esac

MSG="The agent's browsers are not installed on this computer yet: Node.js is missing. Run the Sugar Theme setup skill (/sugar-theme:setup), then start a new conversation."
while IFS= read -r line; do
  id=$(printf '%s' "$line" | sed -nE 's/.*"id"[[:space:]]*:[[:space:]]*("[^"]*"|[0-9]+).*/\1/p')
  [ -z "$id" ] && continue
  case "$line" in
    *'"method"'*'"initialize"'*)
      version=$(printf '%s' "$line" | sed -n 's/.*"protocolVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
      printf '{"jsonrpc":"2.0","id":%s,"result":{"protocolVersion":"%s","capabilities":{"tools":{}},"serverInfo":{"name":"Playwright (not installed)","version":"0"},"instructions":"%s"}}\n' "$id" "${version:-2025-06-18}" "$MSG"
      ;;
    *'"method"'*'"tools/list"'*)
      printf '{"jsonrpc":"2.0","id":%s,"result":{"tools":[{"name":"browser_setup_needed","description":"%s","inputSchema":{"type":"object","properties":{}}}]}}\n' "$id" "$MSG"
      ;;
    *'"method"'*'"tools/call"'*)
      printf '{"jsonrpc":"2.0","id":%s,"result":{"content":[{"type":"text","text":"%s"}],"isError":true}}\n' "$id" "$MSG"
      ;;
    *'"method"'*)
      printf '{"jsonrpc":"2.0","id":%s,"result":{}}\n' "$id"
      ;;
  esac
done
