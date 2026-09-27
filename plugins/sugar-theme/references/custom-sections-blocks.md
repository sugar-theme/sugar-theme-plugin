<!--
Custom sections & blocks log. Copy this file into the project folder as custom-sections-blocks.md.
Every skill that creates a file in the theme, or changes a shipped Sugar file, appends here at the end of the task.

How to use it:
- Append; never rewrite or delete earlier entries. An entry that is no longer true gets a line under it saying so, or a row in Removed.
- One record per new file, under New files, using the fields shown in the example comment. `summary` is one merchant-facing line in the same voice as the Sugar docs: this log is how the next agent learns what exists in this theme beyond the Sugar catalog.
- One row per change to a shipped Sugar file, under Changes to shipped Sugar files. Put the actual lines you added or replaced in the Change column, not a description: there is no version control on the store, so the row is the only record. The update-check skill reads this table to know what a theme update must preserve.
- Read the log before building. A component an earlier agent built may already do the job, and a shipped file may already carry an edit for the same reason.
The examples below are inside comments and are not history. Do not copy them out.
-->

# Custom sections & blocks log

Store: `STORE.myshopify.com` · Working theme: `NAME` (ID `THEME_ID`) · Started: `YYYY-MM-DD`

## New files

<!-- One record per file, in this shape:

### `blocks/example-block.liquid`

- **kind:** block · **name in editor:** Example Block · **category:** Example
- **summary:** One merchant-facing line saying what it does.
- **created:** YYYY-MM-DD by `/sugar-theme:build` on theme `THEME_ID`
- **based on:** `blocks/some-sugar-block.liquid` (copied and changed) | from scratch
- **also created:** `assets/block-example-block.css`, `snippets/example-part.liquid`
- **allowed in:** `blocks/custom-column.liquid`, `blocks/container.liquid`
- **used on:** `templates/product.json`
- **review page:** `/products/handle`
- **notes:** Anything the next agent must know: dependencies on theme engines, a setting that only works in one context, a known limitation.
-->

## Changes to shipped Sugar files

<!-- One row per change. A theme update replaces these files unless it knows to preserve the change. Example row:
| 2026-01-15 | `sections/faq.liquid` | Added `"example-block"` to the `blocks` allowlist | User wanted the block inside FAQ | Yes |
-->

| Date | File | Change (the actual lines) | Why | Keep after update? |
|------|------|---------------------------|-----|--------------------|

## Removed

<!-- Files deleted from the theme, and changes undone. -->

| Date | File | Why |
|------|------|-----|
