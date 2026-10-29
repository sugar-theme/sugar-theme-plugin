# New file creation

How to create new section, block, asset and snippet files on a user's Sugar Theme so they behave like the rest of the theme: editable the way the user expects, fast, and findable by the next agent.

**The conventions themselves live in the theme's own `AGENTS.md`**, which you pulled at the start of the task (store-editing reference): when to build a section or a block, section blocks versus theme blocks, allowlists, naming and categories, every setting pattern (corners, colors, icons, fonts, margins, padding, desktop and mobile values, five or six settings per header), the platform limits that fail silently, where CSS goes, the styling traps, the scripts to reuse, speed, and the design and conversion principles. Follow it. It matches the Sugar release the store runs, and Shopify's Sidekick follows the same file, so what you build and what Sidekick builds come out alike. If the theme has no `AGENTS.md` (an older release), read `${CLAUDE_PLUGIN_ROOT}/references/theme-AGENTS.md`, the newest release's copy, instead.

This reference only adds what you do with the plugin's tools on top of it.

# Ask the user

- **Name and category.** Both show in the theme editor's add menu, so ask with the AskUserQuestion tool (or your agent's equivalent), with your suggestion first. Asset and snippet names are your call.
- **Where a new block should be addable.** Inside Custom Columns means the Column block's allowlist; Container, Row, Slide and others may fit too. Ask which, then make sure it works in each place you add it to.

# Defaults and starting values

- **Icons:** find a default with the MCP's `search_icons` and confirm it with `check_icons`, never from memory. A token that doesn't exist renders nothing.
- **When cloning,** start every setting at the reference's values, on each viewport, so the first preview already matches.
- **Brand:** defaults bind to the theme's variables and palette, never to copied values. `DESIGN.md` says which palette color or scheme fits which job on this store.

# Check the schema

Before you hand off any section or block you created or added settings to, run `node ${CLAUDE_PLUGIN_ROOT}/scripts/schema-check.js FILE...` and fix what it reports. It checks the header groups and the platform rules `AGENTS.md` lists (`visible_if` limits, range steps, allowlists).

# Logging the file

Once the file exists, add an entry to the *Store additions* section at the end of the theme's `AGENTS.md`, below the `<!-- STORE ADDITIONS` line, and push it with the task: the file, what it does, what it was based on, what it depends on, where it is allowed, when to use it and any best practices. Changes to shipped Sugar files go in the second list there, with what changed and why. Future agents, and Sidekick, find it there instead of building it again. Never edit `AGENTS.md` above that line.
