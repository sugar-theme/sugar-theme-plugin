# Sugar Theme MCP

The MCP server bundled with the plugin. This page is the contract the skills are written against: what the server must provide, by tool name, and which skill uses what. Build the server to this; if a tool changes shape, the skill that names it changes with it.

## Where it runs

`POST https://app.sugarthe.me/api/mcp`, an HTTP action on the Sugar app's Convex backend, next to the license verify and download routes; there is no separate MCP host. Sign-in is the app's own Clerk OAuth. It is added once as a custom connector named Sugar Theme in the Claude desktop app. The plugin deliberately does not register it in its own `.mcp.json`: Claude Code's built-in MCP sign-in needs dynamic client registration, which is off on the sign-in service by design, so a bundled entry would only show a connection error at every session start.

## Access

- **Remote MCP at `https://app.sugarthe.me/api/mcp`** (bundled in the plugin's `.mcp.json`; stateless Streamable HTTP), connected once during setup through a browser sign-in with the user's Sugar license. The license identifies the user for every call, so no skill asks for an email, license key or store, and every report and update check is attributed automatically.
- Also usable without the plugin: paste the URL into claude.ai, Cowork or any MCP client. The connect instructions (below) are the whole "how to use Sugar" primer for that audience.
- License-gated. Anything below the theme-editor line (Liquid internals, booster-pack files, full templates, the theme zip) is served only to a valid license, so it can't be pirated by reading the plugin's public repo.

## Connect instructions

The short text every session receives on connect. Two jobs: say what the tools are for, and carry the **global learnings**, the handful of Shopify and CLI gotchas that apply to every task regardless of component (things the platform silently rejects, limits that don't error). This is the "injected at the start of every conversation" channel, so it is kept short and curated hard through the review queue. Nothing that belongs to one component or one skill goes here.

## Tools

### Docs

| Tool | Returns | Used by |
|---|---|---|
| `list_catalog` | Every section, block and feature: name, slug, one-liner, category, status. The live version of the index the plugin ships. | ask, build, freestyle |
| `get_component(slug)` | The component's full docs: what it does, how to set it up, every setting, and its **approved learnings and open bugs**, so an agent that fetches a component's docs gets its gotchas without a second call. | ask, build, clone, enhance |
| `get_concept(slug)` | A mechanism that isn't one component: colors, typography, corners, the landing layout, and the branding read. | build, freestyle, enhance |

### Updates

| Tool | Returns | Used by |
|---|---|---|
| `sugar_updates_since(release)` | Index entries newer than a release: id, type, title, symptoms, files, requires. | update-check |
| `sugar_updates_search(text)` | Index entries whose title or symptoms match, for the "I hit a bug" path. | update-check, feedback |
| `sugar_update(id)` | The change page with its diff and any migration. | update-check |
| `sugar_original(path, release)` | A shipped file as it was at a release, for three-way merges. | update-check |
| `sugar_classify(path, sha256)` | Untouched / customized / unknown, with the base release. | update-check |

### Reports and learnings

| Tool | Returns | Used by |
|---|---|---|
| `report_issue(kind, …)` | Files a `bug`, `learning`, `suggestion` or `feedback`, optionally with a redacted task log and, for a bug the agent fixed itself, the fix (description, diff, verified `yes`/`no`/`unknown`). The server checks bugs and learnings for duplicates and answers either *filed* or *already known* with the existing entry and its workaround. Everything lands in a review queue: approved bugs and learnings distribute to agents; suggestions and feedback go to the Sugar team only. | feedback |
| `share_session(mode, …)` | Sends a task summary (`summaries`) or a redacted conversation (`sessions`) after a task, only when AGENTS.md records that choice. Stored under the user's account, never distributed. | feedback (end of task) |
| `get_learnings(scope)` | Approved learnings and open bugs for a scope: a component slug, a skill name, or `global`. Called by a skill at its first step, never after the error has already happened. | clone, build, freestyle, enhance, speed-optimization |

Bugs carry a status: open, fixed in a release, or won't fix. Open bugs distribute exactly like learnings, scoped to their files, with the workaround and the expected fix. A fixed bug drops out of distribution and becomes an available update, which is the update-check skill's job, so a solved problem never costs context.

### Theme files and templates

| Tool | Returns | Used by |
|---|---|---|
| `get_theme_bundle(release)` | The latest theme zip, for a fresh install or a local copy when an agent needs one. | setup (fresh install only) |
| `list_templates` / `get_template(slug)` | The web app's page templates as JSON, browsable and installable. | build |
| `list_booster_packs` / `get_booster_pack(slug)` | Sections and blocks shipped outside the theme, for tasks the catalog can't do. | build, freestyle |

## Where each learning is delivered

- **Global** (Shopify, the CLI, the platform): in the connect instructions.
- **Per component**: inside `get_component`, fetched before the component is used.
- **Per skill**: `get_learnings(scope)` at the skill's first step.

Search-after-failure is not a delivery path. The point of a learning is to prevent the error, not to explain it afterwards.

## Sharing

Setup asks once whether the user wants to share how they work: `none` (default), `summaries` or `sessions`, recorded as one line in AGENTS.md and changeable there. A summary is a structured recap of one task, a few short paragraphs: the goal, what was built and where, the method, what went wrong and how it was fixed, what was left for later, how the user reacted, plus skill, method and duration as fields. No quotes from the conversation. It is the signal for how people build with Sugar at scale, and it has to stand on its own: a one-line recap is a feedback report, not a summary. Sessions are redacted conversations for users who choose to give them. Both are stored under the user's account and are never distributed to other agents. A task log attached to a report is the same shape as a summary plus the error text, sent per incident on a yes.

## Review queue

Every report enters unapproved. Someone on the Sugar team reads it, turns a learning into a docs line or a global note, turns a bug into a change in the updates index, moves a suggestion to the roadmap, answers or files feedback, or rejects it. Nothing a merchant's agent sends reaches another merchant's agent until then. This is what keeps one agent's mistaken "quirk" from teaching every other agent the same mistake.

## Testing

Plugin and MCP are tested end to end on a clean machine (a UTM or Tart virtual machine) with a fresh Shopify dev store: setup from nothing, one task through each skill, an update check against a customized copy, and a bug report that comes back as a duplicate.
