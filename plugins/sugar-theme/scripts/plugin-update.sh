#!/bin/bash
# Keeps the installed Sugar Theme plugin current without the app's Update button.
#
#   plugin-update.sh check   prints installed=, latest=, status=current|behind|unknown,
#                            then the changelog entries newer than the installed version
#   plugin-update.sh apply   replaces this plugin's own files with the latest release
#
# Only the plugin's own files are replaced (skills, references, scripts, the manifest,
# .mcp.json, CHANGELOG.md). Anything else in the folder belongs to the app and stays.
# Needs curl and tar only: no git, no Node. The new version loads in the next conversation.

REPO="sugar-theme/sugar-theme-plugin"
RAW="https://raw.githubusercontent.com/$REPO/main/plugins/sugar-theme"
TARBALL="https://codeload.github.com/$REPO/tar.gz/refs/heads/main"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OWNED_DIRS="skills references scripts .claude-plugin"
OWNED_FILES=".mcp.json CHANGELOG.md"

version_of() {
  sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1
}

newer() { # newer A B: true when A is a later version than B
  [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$1" ]
}

check() {
  installed="$(version_of < "$ROOT/.claude-plugin/plugin.json")"
  latest="$(curl -fsSL --max-time 10 "$RAW/.claude-plugin/plugin.json" 2>/dev/null | version_of)"
  echo "installed=$installed"
  echo "latest=${latest:-unknown}"
  if [ -z "$latest" ]; then
    echo "status=unknown"
    return 0
  fi
  if newer "$latest" "$installed"; then
    echo "status=behind"
    echo
    # Changelog sections are "## <version>" headings, newest first; print those above the installed one.
    curl -fsSL --max-time 10 "$RAW/CHANGELOG.md" 2>/dev/null |
      awk -v v="$installed" '/^## /{ if ($2 == v) exit; show = 1 } show'
  else
    echo "status=current"
  fi
}

apply() {
  tmp="$(mktemp -d)" || exit 1
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL --max-time 60 "$TARBALL" | tar -xz -C "$tmp" --strip-components=1 || {
    echo "Download failed; nothing was changed." >&2
    exit 1
  }
  new="$tmp/plugins/sugar-theme"
  latest="$(version_of < "$new/.claude-plugin/plugin.json" 2>/dev/null)"
  if [ -z "$latest" ] || [ ! -d "$new/skills" ]; then
    echo "The download doesn't look like the Sugar Theme plugin; nothing was changed." >&2
    exit 1
  fi
  for d in $OWNED_DIRS; do
    rm -rf "${ROOT:?}/$d"
    [ -d "$new/$d" ] && cp -R "$new/$d" "$ROOT/$d"
  done
  for f in $OWNED_FILES; do
    rm -f "${ROOT:?}/$f"
    [ -f "$new/$f" ] && cp "$new/$f" "$ROOT/$f"
  done
  echo "updated=$latest"
}

# One compound command, parsed whole before it runs, so apply can replace this file mid-run.
{
  case "$1" in
    check) check ;;
    apply) apply ;;
    *) echo "usage: plugin-update.sh check|apply" >&2; exit 2 ;;
  esac
  exit $?
}
