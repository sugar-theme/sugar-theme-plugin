# Store editing

How an agent reads and writes files on the user's Sugar Theme. Every skill that touches the theme follows this. The store is the only copy of the theme that counts; anything on the computer is a temporary working copy that exists for one task.

## The rules

1. **The project folder never holds theme files.** Working copies go in a scratch folder of this conversation's own, in the system temp directory.
2. **Pull only what the task touches.** Not the whole theme.
3. **Push only what you changed, and never let a push delete.** Always pass `--nodelete`.
4. **A scratch copy is valid for one task.** Pull again at the start of every task, even if a copy from an earlier task is still there.
5. **Clean up your own folder only.** Delete your scratch folder when the task ends. Other conversations may be working on the same store at the same moment, each in its own folder; never delete theirs.

## Which theme

The working theme's ID and the store come from the project's AGENTS.md. If they are missing, run `/sugar-theme:setup`. The working theme is always a draft unless AGENTS.md says `Live edits: yes`.

**Check the theme's role at the start of every task**, before the first pull, because the user may have published or deleted it since the last session:

```bash
shopify theme list --store STORE.myshopify.com
```

Find the working theme's ID in the list (the first command against a store opens a browser sign-in; the user completes it once):

- **Role is unpublished:** carry on.
- **Role is live and AGENTS.md says `Live edits: no`:** the user published the draft. Duplicate the live theme once (below), record the copy as the working theme in AGENTS.md, and tell the user in one sentence that you made a new draft because the old one went live. Do not ask.
- **Role is live and `Live edits: yes`:** carry on, and say "this is your live theme" before each change.
- **Not in the list:** the theme is gone. Ask which theme to work on, with one button per theme, and record the answer.

The check is by ID, never by name, so two themes with the same name cannot confuse it.

## The scratch folder

Each task makes its own folder, so two conversations working on the same store never share one:

```bash
mktemp -d "${TMPDIR:-/tmp}/sugar-theme-XXXXXX"
```

It prints the folder's full path. Use that exact path, written out, in every command of the task (it is `SCRATCH` below); a variable set in one command doesn't survive to the next. On Windows, make a uniquely named folder under `%TEMP%`.

The user often runs several conversations at once on the same draft, so a folder you didn't make belongs to someone who may still be using it. Leftovers are cleared by age only (see Cleanup).

## Pull

Download only the files the task needs. `--only` takes a path or a glob and can be repeated.

```bash
shopify theme pull --store STORE.myshopify.com --theme THEME_ID \
  --path "SCRATCH" \
  --only templates/product.json --only sections/custom-columns.liquid
```

Pull the JSON template you are editing and every file you plan to change or read. A block or section file you intend to place in a template does not need pulling unless you will edit it.

## Edit

Work on the files in the scratch folder. Before pushing a JSON template, validate it: the file parses, every range value is inside its setting's min and max and on its step, and every block type is allowed by its parent. An invalid value does not error; the upload succeeds and the template silently renders wrong or not at all.

The theme editor and other conversations write files too; the push rule below re-pulls each file right before pushing so a stale copy never overwrites their work.

## Telling the user about a new file

When a task creates a new section or block, tell the user at delivery both the name it shows in the theme editor and its file name, plainly: "it's the block **Trust strip** in the sidebar, file `blocks/trust-strip.liquid`". The editor name is how they find it on the page; the file name is how they or a later agent find it everywhere else, and the two usually differ.

## Push

Upload only the files you changed to the same theme.

```bash
shopify theme push --store STORE.myshopify.com --theme THEME_ID \
  --path "SCRATCH" \
  --only templates/product.json --nodelete
```

- **`--nodelete` is not optional.** Without it, the CLI deletes every remote file that is not in the scratch folder, and the scratch folder holds three files.
- **Pushing to the live theme needs `--allow-live`.** Only when AGENTS.md says `Live edits: yes`, and say so to the user before the push.
- **Pull each file again right before you push it.** Another conversation, or the user in the editor, may have changed it since your copy. If the fresh copy differs from what you pulled, re-apply your change onto the fresh copy and push that. This turns "last push wins" into "last push merges", and it is what lets two conversations share one draft.
- **New files first, the template after.** A template that places a block, or uses a setting, the store doesn't have yet is refused, and the CLI only says "pushed with errors". When a task adds or changes a block, section or snippet that a template uses, push those files first and the template in a second push.
- **Write every `--only` out in the command itself.** A file list kept in a shell variable reaches the CLI as one broken argument in zsh, the Mac's shell, and the push then uploads part of the list without an error.
- **Check what landed.** After a push, pull the same files into a second fresh folder and compare them with yours. A push can report success and still have skipped a file.
- A rejected push prints the error (a Liquid syntax problem, a schema the platform refuses, a range setting with more than 101 steps). The theme keeps its previous version. Fix the file and push again.

## Delete

The CLI has no command to delete one file, and a push without `--nodelete` deletes the whole theme. Use the plugin's script, which deletes exactly the files named and then checks they are gone:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/theme-delete.sh STORE.myshopify.com THEME_ID templates/product.variations.json
```

Name each file in full. It refuses wildcards, core files (layouts, config, each page type's main template) and the live theme; add `--allow-live` only when AGENTS.md says `Live edits: yes`. Delete only files a Sugar task created (a variations template, a losing variation's files), and tell the user in one line what was deleted. A template still assigned to a product or page can't go until that product or page uses another one.

## Duplicate

When setup needs a draft of the live theme, or the working draft has been published:

```bash
shopify theme duplicate --store STORE.myshopify.com --theme LIVE_THEME_ID --name "NAME"
```

Record the new theme's ID in AGENTS.md as the working theme. The user publishes it from the admin when they are happy.

## Preview and review links

Hand the user a **theme editor deep link** to the exact theme and page. They see the full page and can add or remove things themselves:

```
https://admin.shopify.com/store/STORE_HANDLE/themes/THEME_ID/editor?previewPath=%2Fproducts%2FHANDLE
```

`STORE_HANDLE` is the store address without `.myshopify.com`. Always this admin address, never `STORE.myshopify.com/admin/...`: that one detours through the storefront's own address first. The link opens in the user's default browser, which must be signed in to Shopify.

Give the link near the top of the delivery message and again as its last line; a long reply shouldn't make the user scroll back up for it. Encode the path. To open an alternate template, include its `view` query in the path: `%2Fproducts%2FHANDLE%3Fview%3Dvariations`.

For your own checks in the headless browsers, and for anything the editor cannot show (checkout, an app block that needs a real session), use the storefront preview link:

```
https://STORE.myshopify.com/products/HANDLE?preview_theme_id=THEME_ID&pb=0
```

`pb=0` hides Shopify's preview bar, which otherwise sits over the bottom of the page, catches clicks meant for the theme and adds about 420 KB the shopper never downloads.

On a password-protected store the plugin's two browsers open the store already unlocked, from the storefront password in AGENTS.md. Never type the password into the store's password page; if one appears, follow the rule in AGENTS.md.

## Checking your work in the browsers

Each of these sent an earlier agent after a problem that wasn't there:

- **Use the plugin's browsers** (`playwright` for Chrome, `playwright-safari` for Safari) for the store. The app's own built-in browser isn't unlocked and stops at the password page; it is for showing the user something, not for testing.
- **Right after a push, the store can serve the old version for a minute.** If a change isn't there, reload with a throwaway query (`&cb=1`, `&cb=2`…) before deciding something is wrong.
- **Scroll the way a person does**, with the mouse wheel (`page.mouse.wheel`) in small steps. Jumping with `scrollTo` skips past elements, so anything that waits for an element to come into view (sticky bars, counters, reveal effects) never fires and a working feature looks broken.
- **Hide what covers a screenshot.** A sticky header or announcement bar can sit over what you're checking; hide it for the screenshot only.
- **Code run in the browser is browser code.** `require` and other Node features don't exist there; do file work in a shell command.
- **The browsers save files only under `/tmp/playwright-mcp/` or the project folder.** Save screenshots under `/tmp/playwright-mcp/` (or give no path), not in your scratch folder, and delete them when done.
- **A headless browser shows no scrollbar.** A bug that needs a scrollbar taking up space (sideways scrolling in the theme editor's mobile view) won't appear; ask the user where they see it.

## Store data: products, discounts, pages, menus, blog posts, Files and analytics

Theme commands can't touch store data. The Admin API can, through the Shopify CLI, once the user has approved Shopify's command-line app (setup asks for it):

```bash
shopify store execute --store STORE.myshopify.com --query 'query { shop { name } }'
shopify store execute --store STORE.myshopify.com --query-file mutation.graphql --variable-file vars.json --allow-mutations
```

- Reads run as they are. A write only runs with `--allow-mutations`, and every write is live on the store the moment it runs, draft theme or not. Say what it will create or change and get a yes first.
- "Not authorised", an expired token or a missing permission all mean the same fix: run the approval again, and tell the user a Shopify page will ask them to approve.

  ```bash
  shopify store auth --store STORE.myshopify.com --scopes read_products,write_products,read_discounts,write_discounts,read_publications,write_publications,read_inventory,write_inventory,read_locations,read_files,write_files,read_online_store_pages,write_online_store_pages,read_online_store_navigation,write_online_store_navigation,read_content,write_content,read_metaobjects,write_metaobjects,read_metaobject_definitions,write_metaobject_definitions,read_reports
  ```
- Uploading an image to Files: `stagedUploadsCreate` returns an upload URL and form fields; POST the file there with `curl`; then `fileCreate` with the returned resource URL and alt text. A template references it as `shopify://shop_images/<filename>`. If any step fails, hand the user the file instead.
- Analytics are read-only: `shopifyqlQuery` answers questions like a page's sessions and conversion rate, so a change can be measured before and after. Totals only: setup's approval leaves out orders and customers. If a task needs them, ask the user and re-run the approval with those permissions added.
- A product's template is its `templateSuffix` (`productUpdate`); a page's is the page's `templateSuffix` (`pageCreate` / `pageUpdate`).

## When a full local copy is needed

Some work wants the CLI's local preview server, which reloads as you edit. On a password-protected store, add `--store-password` with the storefront password from AGENTS.md:

```bash
shopify theme dev --store STORE.myshopify.com --theme THEME_ID --path "SCRATCH"
```

It requires the whole theme in the scratch folder, so pull without `--only` first. It uploads the scratch folder to the theme it is pointed at as you edit, so point it at the working theme, never the live one. Treat the full copy like any other scratch: valid for this task, deleted at the end.

## Cleanup

When the task ends, delete your own folder, and only yours:

```bash
rm -rf "SCRATCH"
```

At the start of a task, clear leftovers at least a day old, which no running conversation is still using:

```bash
find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'sugar-theme*' -mtime +0 -exec rm -rf {} +
```

Never delete a newer folder, even one that looks abandoned. Screenshots the user should keep go in the project folder, not the scratch.
