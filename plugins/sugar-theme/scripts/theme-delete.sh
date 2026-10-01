#!/bin/bash
# Deletes named files from a theme on the store, and nothing else.
#
#   theme-delete.sh STORE.myshopify.com THEME_ID templates/product.variations.json [more files...]
#   theme-delete.sh ... --allow-live    (only when AGENTS.md says Live edits: yes)
#
# The Shopify CLI has no delete command for a single file. A push deletes every remote
# file it was told about that the local folder doesn't have, so this pushes from an empty
# folder with one --only per named file: exactly those files go, and nothing else is
# touched. Every name is checked first, because a push without --only would delete the
# whole theme. Then the files are pulled back to confirm they are gone.

STORE="$1"
THEME="$2"
shift 2 2>/dev/null
ALLOW_LIVE=""
FILES=()
for a in "$@"; do
  if [ "$a" = "--allow-live" ]; then ALLOW_LIVE="--allow-live"; else FILES+=("$a"); fi
done

fail() { echo "$1" >&2; exit 1; }

case "$STORE" in *.myshopify.com) ;; *) fail "usage: theme-delete.sh STORE.myshopify.com THEME_ID FILE [FILE...] [--allow-live]" ;; esac
case "$THEME" in ''|*[!0-9]*) fail "THEME_ID must be the theme's number." ;; esac
[ "${#FILES[@]}" -gt 0 ] || fail "Name at least one file to delete."

# Files the theme can't work without, which no task ever deletes.
PROTECTED=" layout/theme.liquid layout/password.liquid config/settings_schema.json config/settings_data.json "
for f in "${FILES[@]}"; do
  case "$f" in
    *'*'*|*'?'*|*'['*|*'..'*|/*) fail "Refused: $f. Name one file exactly, with no wildcards." ;;
    templates/*.json|templates/*.liquid|templates/customers/*|sections/*.liquid|blocks/*.liquid|snippets/*.liquid|assets/*) ;;
    *) fail "Refused: $f. Only templates, sections, blocks, snippets and assets can be deleted this way." ;;
  esac
  case "$PROTECTED" in *" $f "*) fail "Refused: $f is a core theme file." ;; esac
  # The base template of each page type: the store needs it even when a page uses an alternate.
  case "$f" in
    templates/[a-z_]*.json|templates/[a-z_]*.liquid)
      base="${f#templates/}"; base="${base%.*}"
      case "$base" in *.*) ;; *) fail "Refused: $f is a page type's main template." ;; esac ;;
  esac
done

# Never the live theme unless the caller says AGENTS.md allows live edits.
ROLE="$(shopify theme list --store "$STORE" --id "$THEME" --json 2>/dev/null | sed -n 's/.*"role"[[:space:]]*:[[:space:]]*"\([a-z]*\)".*/\1/p' | head -1)"
[ -n "$ROLE" ] || fail "Theme $THEME was not found on $STORE (or the CLI is not signed in). Nothing was deleted."
if [ "$ROLE" = "live" ] && [ -z "$ALLOW_LIVE" ]; then
  fail "Theme $THEME is the live theme. Nothing was deleted."
fi

EMPTY="$(mktemp -d "${TMPDIR:-/tmp}/sugar-theme-delete-XXXXXX")" || exit 1
CHECK="$(mktemp -d "${TMPDIR:-/tmp}/sugar-theme-delete-check-XXXXXX")" || exit 1
trap 'rm -rf "$EMPTY" "$CHECK"' EXIT
mkdir -p "$EMPTY"/{assets,blocks,config,layout,locales,sections,snippets,templates/customers}

ONLY=()
for f in "${FILES[@]}"; do ONLY+=(--only "$f"); done

OUT="$(shopify theme push --store "$STORE" --theme "$THEME" --path "$EMPTY" "${ONLY[@]}" $ALLOW_LIVE 2>&1)"
STATUS=$?
if [ $STATUS -ne 0 ] || printf '%s' "$OUT" | grep -qi "error"; then
  printf '%s\n' "$OUT" | sed 's/\x1b\[[0-9;]*[A-Za-z]//g' | grep -v '^[[:space:]]*$' | tail -20 >&2
  fail "The delete reported an error (above). Check the files below."
fi

# Confirm: pulling the same names back should find none of them.
shopify theme pull --store "$STORE" --theme "$THEME" --path "$CHECK" "${ONLY[@]}" >/dev/null 2>&1
LEFT=0
for f in "${FILES[@]}"; do
  if [ -e "$CHECK/$f" ]; then echo "still there: $f"; LEFT=1; else echo "deleted: $f"; fi
done
exit $LEFT
