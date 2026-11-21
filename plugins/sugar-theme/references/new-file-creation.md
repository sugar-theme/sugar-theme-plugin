# New file creation

How to create new section, block, asset and snippet files on a user's Sugar Theme so they behave like the rest of the theme: editable the way the user expects, fast, and findable by the next agent.

**The conventions themselves live in the theme's own `AGENTS.md`**, which you pulled at the start of the task (store-editing reference): when to build a section or a block, section blocks versus theme blocks, allowlists, naming and categories, every setting pattern (corners, colors, icons, fonts, margins, padding, desktop and mobile values, five or six settings per header), the platform limits that fail silently, where CSS goes, how to print copy so it updates as the merchant types, the styling traps, the scripts to reuse, speed, and the design and conversion principles. Follow it. It matches the Sugar release the store runs, and Shopify's Sidekick follows the same file, so what you build and what Sidekick builds come out alike. If the theme has no `AGENTS.md` (an older release), read `${CLAUDE_PLUGIN_ROOT}/references/theme-AGENTS.md`, the newest release's copy, instead.

This reference only adds what you do with the plugin's tools on top of it.

# Ask the user

- **Name and category.** Both show in the theme editor's add menu, so ask with the AskUserQuestion tool (or your agent's equivalent), with your suggestion first. Asset and snippet names are your call.
- **Where a new block should be addable.** Inside Custom Columns means the Column block's allowlist; Container, Row, Slide and others may fit too. Ask which, then make sure it works in each place you add it to.

# Defaults and starting values

- **Icons:** find a default with the MCP's `search_icons` and confirm it with `check_icons`, never from memory. A token that doesn't exist renders nothing.
- **When cloning,** start every setting at the reference's values, on each viewport, so the first preview already matches.
- **Brand:** defaults bind to the theme's variables and palette, never to copied values. `DESIGN.md` says which palette color or scheme fits which job on this store.

# Print copy settings directly

A store on an older Sugar release has an `AGENTS.md` without this rule, so it is repeated here.

A `text`, `textarea`, `inline_richtext` or `richtext` setting printed as `{{ block.settings.x }}` updates in the theme editor as the merchant types, with no section reload. Printed through a variable, another filter or a snippet parameter, every keystroke reloads the whole section, which is slow on a long page and sometimes never answers. Print copy the direct way wherever no script changes the text after the page loads.

- **`richtext` and `inline_richtext`:** print the setting bare, anywhere in the markup. Use these types for headings and paragraphs.
- **`text` and `textarea`:** the bare output (or `| escape`) must be the only thing inside an element whose opening tag has no Liquid in it: `<span class="x__label">{{ block.settings.label }}</span>`. Liquid in the tag (`class="{{ … }}"`, `href="{{ … }}"`), anything else beside the output, or a Liquid tag between the element and the output reloads the section. When the outer element needs Liquid in its tag, give the text its own plain inner element.
- **Copy that needs processing** (placeholders): process into a variable, then print the setting itself whenever processing left it unchanged: `{% if processed == block.settings.text %}{{ block.settings.text }}{% else %}{{ processed }}{% endif %}`. For `text` settings put the whole element in both branches.
- **Keep the element in the editor when the copy is blank:** `{% if block.settings.text != blank or request.design_mode %}`, so typing into an emptied field updates in place too, and hide it while empty with `:empty` (the theme already hides an empty `div`, `p` and `h1`-`h6`).
- **A snippet stays direct** when it receives the object (`render 'card', block: block`) and prints `{{ block.settings.x }}` itself. Passing the text in as a parameter does not.
- **Not where a script owns the text** (button labels that change state, prices, counters, rotating text): leave those printed through the script's own template.

# Check the schema

Before you hand off any section or block you created or added settings to, run `node ${CLAUDE_PLUGIN_ROOT}/scripts/schema-check.js FILE...` and fix what it reports. It checks the header groups and the schema rules `AGENTS.md` lists (`visible_if` limits, range steps, a misplaced `category`, a `url` default other than `/`, `/collections` or `/collections/all`, an `enabled_on`/`disabled_on` group Shopify doesn't have, or both of those set). It does not read templates: before pushing one, check that each section and block holds no more blocks than its schema's `max_blocks` (50 when none is set), only block types it allows, and range values inside their `min`/`max`.

# Logging the file

Once the file exists, add an entry to the *Store additions* section at the end of the theme's `AGENTS.md`, below the `<!-- STORE ADDITIONS` line, and push it with the task: the file, what it does, what it was based on, what it depends on, where it is allowed, when to use it and any best practices. Changes to shipped Sugar files go in the second list there, with what changed and why. Future agents, and Sidekick, find it there instead of building it again. Never edit `AGENTS.md` above that line.
