---
name: feedback
description: Send the Sugar team a bug, a learning, a suggestion or general feedback about the Sugar Theme, the plugin or the app, without the user leaving the conversation. Use when a bug surfaces in an unedited Sugar file, when you or the user catch a mistake you made, when you learn something every agent working on Sugar should know, when the user wishes something existed, or when a task ended in frustration. Check for updates first; a bug may already be fixed.
disable-model-invocation: false
---

# Overview

One report goes to the Sugar team through the Sugar Theme MCP. It has four kinds:

- **bug** in a shipped Sugar file, or an issue that hit you while working on the user's theme.
- **learning:** a mistake you made using existing Sugar files, a gotcha the docs didn't cover, or a quirk of Shopify or the CLI that cost time. Once reviewed, learnings reach every other agent working on Sugar so nobody hits the same thing twice.
- **suggestion:** something the user or you wish existed, in the theme, the plugin or the app. Goes to the roadmap, not to other agents.
- **feedback:** anything else, including praise, confusion, or "that's not what I meant". Offer it when a task ends with visible frustration.

The user never leaves the conversation and never fills in a form. The MCP knows who they are from their license, so you do not ask for their email, license key or store.

# Step 1: Check before you send

1. **Is it already fixed?** For a bug, search the updates index by symptom through the update-check skill. If a change matches, apply it instead of reporting it.
2. **Is it already known?** The report tool checks for duplicates itself and answers with the existing entry when it finds one. Read it: it may carry a workaround, and you are done.
3. **Is it a bug at all?** A file you or another agent edited is not a Sugar bug; check the project's `custom-sections-blocks.md` before blaming the shipped file. A setting that does nothing is a bug, not a quirk.

# Step 2: Report

Send the report with the MCP's report tool, with its kind and:

- **Files affected**, by path, with the release stamp from each file's first line, and the theme's `theme_version`. Bugs and learnings only.
- **Description:** what was expected, what happened, on which page and device. For a bug, the steps to reproduce it. For a learning, the wrong way and the right way, so it can become a docs line. For a suggestion, what it would let the user do that they can't today.
- **What you tried**, and the workaround if you found one.
- **The fix you applied**, if you fixed a bug in a shipped Sugar file yourself: what you changed and why, a unified diff of the file against the original, and whether you saw it working in the browser (`yes`), tried it and it didn't help (`no`), or applied it without checking (`unknown`). Send it either way; a fix that didn't work is still a lead.
- **Where to see it:** the storefront preview link to the page, if the user is fine sharing it.
- **Date.**

## When you fixed it yourself

Don't wait for the Sugar team. If a shipped Sugar file has a bug and you can fix it, fix it in the user's theme, verify it, and log the file in `custom-sections-blocks.md` the way any edited Sugar file is logged. Then report the bug with the fix attached. The report is what lets the fix ship to every store in the next release; without it, the user's copy stays patched and everyone else keeps hitting it.

## Attaching the task log

When a task failed, or you made a mistake you had to walk back, offer once to attach the task log: your own recap of what you tried and the error text, not the conversation. Ask in the moment, the way an app asks whether to send a crash report, and send it only on a yes. Before sending, strip anything that looks like a token, a password, an email address or customer data.

# Step 3: Say what you sent

Tell the user in one line what was sent and what came back: filed as new, or already known, with any workaround it returned. Reports enter a review queue; only approved learnings and open bugs are distributed to other agents, and suggestions and feedback go to the Sugar team, so nothing a user sends is visible to anyone else the moment it is sent.

# Standing sharing

Separate from reports, the project's AGENTS.md records a sharing choice the user made during setup: `none`, `summaries` or `sessions`. Honour it exactly.

- **none:** send nothing beyond the reports above. This is the default.
- **summaries:** at the end of each task, send a structured recap of the whole task, a few short paragraphs, not a sentence: what the user set out to do, what was built and where (sections and blocks by their display names, new files by name), which method and why, what went wrong and how it was fixed, what was left for later, and how the user reacted. Long enough to understand the task without reading the conversation, never longer than about 300 words, and never a quote from the user's messages. A long session produces one recap per task, not one for the session. Send it through the MCP's session tool with the skill, the creation method and the time taken as fields.
- **sessions:** send the task's conversation as well, redacted the same way as a log.

Never send from a sub-agent, never send when the choice is missing, and when you do send, say so in one line. The user changes their mind by editing the line in AGENTS.md.
