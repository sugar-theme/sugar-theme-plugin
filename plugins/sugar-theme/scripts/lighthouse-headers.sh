#!/bin/bash
# Prepares a Lighthouse run against the working theme, on a storefront that may be
# password-protected:
#
#   lighthouse-headers.sh STORE.myshopify.com THEME_ID
#
# Prints three lines: host=<the storefront's host>, headers=<a file for Lighthouse's
# --extra-headers> and chrome=<a browser for Lighthouse's CHROME_PATH>, empty when
# Google Chrome is installed and Lighthouse finds it on its own. The file carries Shopify's cookie, which holds both the storefront
# unlock (from the password in the project's AGENTS.md) and the choice of preview theme, so
# Lighthouse tests the plain page address: no password page, no preview_theme_id redirect
# on every run. Add ?pb=0 to the tested address to hide the preview bar.

STORE="$1"
THEME="$2"
fail() { echo "$1" >&2; exit 1; }
case "$STORE" in *.myshopify.com) ;; *) fail "usage: lighthouse-headers.sh STORE.myshopify.com THEME_ID" ;; esac
case "$THEME" in ''|*[!0-9]*) fail "THEME_ID must be the theme's number." ;; esac

agents="${CLAUDE_PROJECT_DIR:-$PWD}/AGENTS.md"
pw=""
[ -f "$agents" ] && pw="$(sed -n 's/.*\*\*Storefront password:\*\*[[:space:]]*//p' "$agents" | head -1 | sed 's/[[:space:]]*$//')"
[ "${pw#[}" = "$pw" ] || pw=""

# The store may answer on its own domain; the cookie belongs to whichever host it lands on.
host="$(curl -sL -o /dev/null --max-time 10 -w '%{url_effective}' "https://$STORE/" | sed -E 's#^https?://([^/]+).*#\1#')"
[ -n "$host" ] || fail "The storefront didn't answer."

jar="$(mktemp)"; page="$(mktemp)"
trap 'rm -f "$jar" "$page"' EXIT
if [ -n "$pw" ]; then
  code="$(curl -s -o /dev/null --max-time 10 -w '%{http_code}' -b "$jar" -c "$jar" \
    --data-urlencode "form_type=storefront_password" --data-urlencode "password=$pw" "https://$host/password")"
  # 302 means Shopify accepted the password; a 200 re-renders the page, so it was wrong.
  [ "$code" = "302" ] || fail "The storefront password in AGENTS.md was refused. Ask the user for the current one."
fi

# One visit with preview_theme_id stores the theme choice in the same cookie.
curl -sL -o /dev/null --max-time 15 -b "$jar" -c "$jar" "https://$host/?preview_theme_id=$THEME"
# Then confirm a plain visit, with only the cookie, gets the working theme and not the password page.
landed="$(curl -sL -o "$page" --max-time 15 -b "$jar" -w '%{url_effective}' "https://$host/")"
case "$landed" in */password*) fail "The store still shows its password page. Add the storefront password to AGENTS.md (setup does this), or ask the user for the current one." ;; esac
grep -q "Shopify.theme = {[^}]*\"id\":$THEME[,}]" "$page" ||
  fail "The plain page isn't serving theme $THEME, so the measurement would be of another theme."

# The jar marks HttpOnly cookies with a "#HttpOnly_" prefix; those are the ones that matter.
cookie="$(awk 'BEGIN{FS="\t"} /^#HttpOnly_/ {sub(/^#HttpOnly_/, "")} !/^#/ && NF >= 7 {printf "%s%s=%s", (n++ ? "; " : ""), $6, $7}' "$jar")"
[ -n "$cookie" ] || fail "Shopify set no cookie."

headers="$(umask 077; mktemp "${TMPDIR:-/tmp}/sugar-lighthouse-XXXXXX")"
printf '{"Cookie": "%s"}\n' "$(printf '%s' "$cookie" | sed 's/["\\]/\\&/g')" > "$headers"
# Without Google Chrome, Lighthouse runs on the Chromium that setup installed for the
# agent's browsers. A Windows path is printed with forward slashes, which Node reads.
chrome=""
case "$(uname -s)" in
  Darwin)
    [ -d "/Applications/Google Chrome.app" ] || [ -d "$HOME/Applications/Google Chrome.app" ] ||
      chrome="$(ls -d "$HOME"/Library/Caches/ms-playwright/chromium-*/chrome-mac*/"Google Chrome for Testing.app"/Contents/MacOS/"Google Chrome for Testing" 2>/dev/null | tail -1)" ;;
  MINGW*|MSYS*|CYGWIN*)
    found=""
    for dir in "$LOCALAPPDATA" "$PROGRAMFILES" "${PROGRAMW6432:-}" "$(printenv 'PROGRAMFILES(X86)')"; do
      [ -n "$dir" ] && [ -f "$(cygpath -u "$dir")/Google/Chrome/Application/chrome.exe" ] && found=1
    done
    # Setup puts the engines in the home folder (see playwright-mcp.sh: the packaged
    # Claude app can't start Chromium from a folder it created in AppData\Local).
    # Older setups left them in Playwright's default folder.
    if [ -z "$found" ]; then
      for dir in "$PLAYWRIGHT_BROWSERS_PATH" "${USERPROFILE:+$USERPROFILE/.cache/ms-playwright}" "${LOCALAPPDATA:+$LOCALAPPDATA/ms-playwright}"; do
        [ -n "$dir" ] && [ -z "$chrome" ] || continue
        chrome="$(ls -d "$(cygpath -u "$dir")"/chromium-*/chrome-win*/chrome.exe 2>/dev/null | tail -1)"
      done
    fi
    [ -n "$chrome" ] && chrome="$(cygpath -m "$chrome")" ;;
  *)
    command -v google-chrome >/dev/null 2>&1 || command -v google-chrome-stable >/dev/null 2>&1 ||
      chrome="$(ls -d "$HOME"/.cache/ms-playwright/chromium-*/chrome-linux*/chrome 2>/dev/null | tail -1)" ;;
esac

echo "host=$host"
echo "headers=$headers"
echo "chrome=$chrome"
