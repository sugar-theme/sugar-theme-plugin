# Sugar Theme plugin

Skills and references that teach an AI agent to edit a Shopify store built on the [Sugar Theme](https://sugarthe.me).

## Install

**Claude desktop app, one paste** (the recommended path). Make an empty folder for your store, start a new conversation in it, and paste:

```
Set up the Sugar Theme for me in this folder.

1. Download the setup files: run `mkdir -p ~/.sugar-theme-setup && curl -fsSL https://github.com/sugar-theme/sugar-theme-plugin/archive/refs/heads/main.tar.gz | tar -xz -C ~/.sugar-theme-setup --strip-components=1`
2. Open ~/.sugar-theme-setup/plugins/sugar-theme/skills/setup/SKILL.md and follow it from start to finish.
```

The agent installs the tools, connects your store, writes the project's `AGENTS.md` and adds the plugin to the folder. Plugins, their skills and their browsers only load when a conversation starts, so it then asks you to open one new conversation in the same folder. That one installs the plugin, has you sign in to Sugar once, checks the browsers, and you're ready.

**Claude desktop app, by hand:**

1. Click the **+** button at the bottom of the chat, then **Plugins**, then **Add marketplace**.
2. Paste `sugar-theme/sugar-theme-plugin` and click **Sync**. If the app says it failed, the marketplace may already be added; check the plugin list before retrying.
3. Find **sugar-theme** in the plugin list and click **Install**.
4. Start a new conversation in an empty folder for your store and type `/sugar-theme:setup`. On a computer without Node.js, the agent's browsers switch on one conversation later.

**Claude Code in a terminal:**

```
/plugin marketplace add sugar-theme/sugar-theme-plugin
/plugin install sugar-theme@sugar
```

Then restart and run `/sugar-theme:setup` in an empty folder.

## Other agents

Claude is the recommended and tested path. The skills use the open `SKILL.md` format, so agents that read it can use the same repo. Codex reads skills from `~/.codex/skills/`, one folder per skill; the shared `references/` folder has to stay next to the skills, so clone the whole repo and link the skill folders in. Paste this into Codex and let it do the work:

```
Install the Sugar Theme skills for me: clone https://github.com/sugar-theme/sugar-theme-plugin
into ~/.sugar-theme-plugin, then create a symbolic link in ~/.codex/skills/ for each folder
inside ~/.sugar-theme-plugin/plugins/sugar-theme/skills/. Tell me when to restart you.
```

Then connect the Sugar Theme MCP in Codex's MCP settings with the address in `docs/MCP.md`, restart, and run the `setup` skill in a fresh project folder. Setup writes `AGENTS.md`, which Codex reads natively. To update, pull the clone. This path is not yet tested end to end.

## Layout

- `plugins/sugar-theme/skills/` — one folder per skill (`setup`, `clone`, `build`, `freestyle`, `ask`, `enhance`, `variations`, `speed-optimization`, `update-check`, `feedback`)
- `plugins/sugar-theme/references/` — shared documents the skills read: `store-editing`, `creation-methods`, `new-file-creation`, `variations`, `custom-sections-blocks` (log template), `catalog-index` (generated)
- `docs/MCP.md` — the contract for the Sugar Theme MCP the skills call

Only content a merchant can see in the theme editor lives here. Liquid internals and gated material are served by the MCP behind a license.
