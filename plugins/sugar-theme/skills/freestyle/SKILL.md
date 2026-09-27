---
name: freestyle
description: Create custom sections and blocks in the user's theme as completely new files, without composing them from the theme's existing sections and blocks. Use when the user asks for something in "freestyle" mode or specifically without existing theme components. They may give a goal or references as direction. This is the build skill's sibling, invoked only for creations that do not use existing components. Not for tasks the theme's existing components can do; that is build.
disable-model-invocation: false
---

# Overview

Create sections and blocks inside the user's theme with complete freedom. Instead of treating the existing files as a component library, you are free to create anything that fulfils the user's request, as new files on their theme.

# Prerequisites

- **Sugar Theme** installed on the user's Shopify store. New files still lean on its engines, icons, fonts and settings.
- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first.
- **Target template and product** named by the user, so you know where the new section or block goes and whether a particular product should be linked.
- **A goal, concept or idea**, and optionally references for direction.

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 1: Brainstorm

Thoroughly analyze the user's request, their existing design components, their styling, their brand, their target audience and, most importantly, their product. Think about the different ways their goal, idea or concept can be materialized.

Read the working theme's brand settings before proposing anything: the new file will bind to the theme's typography, color schemes, corners and buttons, so every option should be imagined in the user's type and colors, not generic ones. Read the project's `custom-sections-blocks.md` too, in case an earlier agent already built something close.

Because this skill is usually invoked in an exploratory prompt or phase, offer the user multiple options for what can be created. Present them with the AskUserQuestion tool (or your agent's equivalent), saying clearly what each section or component would look like and why it is a good fit for the goal.

Say which images the build needs and why before building, and offer to create them with an image tool the user has connected, such as the Higgsfield MCP or a similar generator, or to use images already in their store or on their computer. Never ship a placeholder where an image should be unless the user wants to defer the creation of the image until later.

The user may like more than one suggestion and ask to see them all built before picking a final version. Read `${CLAUDE_PLUGIN_ROOT}/references/variations.md` so you know exactly how to build and deliver variations in context on the theme.

# Step 2: Build

**Before starting, make sure you know exactly which template and, where relevant, which product you are building on.** The theme itself comes from AGENTS.md. If the user has not named the template or product, and nothing in the project says which to use, ask. Do not assume. If the working theme is the live theme, say so before you change it.

Once the user has decided on a concept, build the new files on their theme. Name every section and block you place, as described in the store-editing reference, so the editor's sidebar says what it is and where it sits. Read `${CLAUDE_PLUGIN_ROOT}/references/new-file-creation.md` first and follow it: it covers choosing between section and theme blocks, the settings the user expects to find, the theme features to reuse, performance, and the design habits that make a file look generated rather than designed.

Ask the user for the name and category the new section or block should show in the theme editor, since those are what they will see. When the build is done, log every new file in the project's `custom-sections-blocks.md` with what it does, what it depends on and when to use it, so future agents find it instead of building it again.

# Step 3: Verification

Once the section or component is on the theme, verify that it looks and works properly. Open the page's preview so you see it the way a live customer would. Click around to test its functionality. Check both viewports, in both Chrome and Safari using the two headless browsers installed by setup; desktop may look right while mobile has bugs.

If the build has any bugs or visual quirks, diagnose the cause, fix it and test again. The task is not complete until the delivery looks polished and is fully functional.

# Step 4: Delivery & Revisions

After reviewing the build thoroughly, deliver it with clear, concise instructions on how and where to review it: a theme editor deep link to the exact theme and page, so the user can see the full page and adjust things themselves. Tell them the new file's name and where it appears in the editor's add menu. The user may request changes or improvements.

If variations were built, the user may ask for elements of several to be merged, or have new ideas from seeing them. Once a winner is chosen, move it into the real template, delete the losing files from the theme, and clean up the variations scaffold.
