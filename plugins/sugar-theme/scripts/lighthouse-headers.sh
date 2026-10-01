#!/bin/bash
# Prepares a Lighthouse run against the working theme, on a storefront that may be
# password-protected:
#
#   lighthouse-headers.sh STORE.myshopify.com THEME_ID
#
# Prints two lines: host=<the storefront's host> and headers=<a file for Lighthouse's
# --extra-headers>. The file carries Shopify's cookie, which holds both the storefront
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
echo "host=$host"
echo "headers=$headers"
