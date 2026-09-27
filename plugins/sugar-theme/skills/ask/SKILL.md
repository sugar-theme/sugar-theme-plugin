---
name: ask
description: Teaches the user how to use the Sugar Theme's features, tells them whether a feature exists, and offers to do the task for them, by looking closely at the theme's catalog of sections, blocks, features and their settings. Use when the user has a question about how to use the theme but has not yet asked for something to be built. Not for making a change; once the user asks for something to be built or improved, hand off to build, clone, enhance or freestyle.
disable-model-invocation: false
---

# Overview

Answer questions about the Sugar Theme and about the other files and features in the user's theme.

# Step 1: Review

Analyze the user's request thoroughly. Read between the lines, especially when the prompt is brief, so you can infer the overall goal behind the question.

Once you have a clear idea of the result they actually want, look at what their theme can do:

- **The Sugar catalog.** The plugin's catalog index tells you at a glance whether a section, block or feature exists. For how a specific component works and what its settings do, fetch its docs through the Sugar Theme MCP; the docs also carry that component's known issues and learnings.
- **Files built by other agents.** Anything created in this theme beyond the Sugar catalog is documented in the project's `custom-sections-blocks.md`. Check it before saying a feature does not exist.
- **The page in question.** When the question is about a page the user already has, read its template from the working theme (see `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`) so the answer refers to the sections and blocks actually on it. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 2: Educate & Suggest

After analyzing the request and the resources available, explain how the user can achieve it and which tools they have for it. In many cases there are several ways to reach the goal, each with its own considerations and trade-offs; lay them out plainly.

When the answer is "use this setting" or "add this block", say where it is in the theme editor and give a theme editor deep link to the exact theme and page, so the user can do it themselves in the place they already work.

Assume the user is not technical. Explain in the language of an operator, not a developer.

# Step 3: Offer to Build

Go above and beyond: offer to complete the task for the user so they don't have to do it themselves. Route the offer to the right skill, so the user knows what they are saying yes to:

- **Build** when the goal can be met with the theme's existing components, or with new files if needed.
- **Clone** when they have a reference they want matched.
- **Enhance** when the thing already exists on their page and they want it better.
- **Freestyle** when they specifically want new files and no existing components.

When there is a gap between what exists and what they want, describe the limitation honestly and offer a way to close it. The methods for adding features are in `${CLAUDE_PLUGIN_ROOT}/references/creation-methods.md`.
