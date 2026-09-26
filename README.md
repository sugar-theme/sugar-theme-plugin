# Sugar Theme plugin

Skills and references that teach an AI agent to edit a Shopify store built on the [Sugar Theme](https://sugarthe.me).

## Install

Open the Claude desktop app, start a new conversation in an empty folder for your store, and paste this:

```
Set up the Sugar Theme plugin for me so I can edit my Shopify store from here.

1. Install the plugin by running these two commands yourself:
   claude plugin marketplace add sugar-theme/sugar-theme-plugin
   claude plugin install sugar-theme@sugar
   If `claude` is not found, use the copy bundled with this app: the newest folder under
   ~/Library/Application Support/Claude/claude-code/, file claude.app/Contents/MacOS/claude.
2. Then run the plugin's setup skill: /sugar-theme:setup. If it isn't available in this
   conversation yet, tell me to start a new conversation and type /sugar-theme:setup there.
3. Do everything you can yourself and never tell me to open a terminal. When you need
   something from me, ask one clear question at a time.
```

Setup checks the tools, connects your store and the Sugar Theme MCP, and writes the project's `AGENTS.md`. Auto-update for the `sugar` marketplace is part of setup, so the skills stay current.

In a terminal, the same two lines work as slash commands: `/plugin marketplace add sugar-theme/sugar-theme-plugin` and `/plugin install sugar-theme@sugar`, then `/sugar-theme:setup`.

## Other agents

Claude Code is the recommended and tested path. The skills use the open `SKILL.md` format, so agents that read it can use the same repo. For Codex, Cursor or Gemini CLI, install the skills with the community installer:

```
npx skills add sugar-theme/sugar-theme-plugin
```

Then connect the Sugar Theme MCP by hand in your agent's MCP settings, and run the `setup` skill in a fresh project folder. The setup skill writes `AGENTS.md`, which those agents read natively. Marketplace auto-update is a Claude Code feature; other agents re-run the installer to update.

## Layout

- `skills/` — one folder per skill (`setup`, `clone`, `build`, `freestyle`, `ask`, `enhance`, `variations`, `speed-optimization`, `update-check`, `feedback`)
- `references/` — shared documents the skills read: `store-editing`, `creation-methods`, `new-file-creation`, `variations`, `custom-sections-blocks` (log template), `catalog-index` (generated)
- `docs/MCP.md` — the contract for the Sugar Theme MCP the skills call

Only content a merchant can see in the theme editor lives here. Liquid internals and gated material are served by the MCP behind a license.
