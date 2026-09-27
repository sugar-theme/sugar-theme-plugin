---
name: build
description: Create sections and blocks in the user's theme from a goal or idea, using existing Sugar Theme files or completely new ones. Use when the user has a goal or an idea for a component, feature or section but gives no reference to clone. If they do share references, they are for direction and inspiration, not for cloning. Not for improving something already on the page; that is enhance. Not for matching a reference exactly; that is clone.
disable-model-invocation: false
---

# Overview

Create blocks and sections inside the user's Sugar Theme based on a general goal or idea.

# Prerequisites

- **Sugar Theme** installed on the user's Shopify store, so sections can be built from existing components.
- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first.
- **Target template and product** named by the user, so you know where to build and whether a particular product should be linked.
- **A goal, concept or idea** for what will be built. Example prompt: "I want to build a section that displays authority on our product page that includes images and endorsements of clinical experts."

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 1: Brainstorm

Thoroughly analyze the user's request, their existing design components, their styling, their brand, their target audience and, most importantly, their product. Think about the different ways their goal, idea or concept can be materialized.

Ground the options in what the theme can do. Read the plugin's catalog index to see which Sugar sections and blocks exist, and the project's `custom-sections-blocks.md` for files other agents have built in this theme. Read the working theme's brand settings so every option is proposed in the user's typography and colors, not generic ones.

Because this skill is usually invoked in an exploratory prompt or phase, offer the user multiple options for what can be created. Present them with the AskUserQuestion tool (or your agent's equivalent), saying clearly what each section or component would look like and why it is a good fit for the goal.

Say which images the build needs and why before building, and offer to create them with an image tool the user has connected, such as the Higgsfield MCP or a similar generator, or to use images already in their store or on their computer. Never ship a placeholder where an image should be unless the user wants to defer the creation of the image until later.

# Step 2: Method Selection

Once the user has decided on a concept, or has opted for several to be built as variations, decide which method or methods you will use to build it. Read `${CLAUDE_PLUGIN_ROOT}/references/creation-methods.md` to sort through the options, then give the user the recommended ones before starting so they know how the result will look and feel and what its limitations are.

## Variations

The user may want different variations built so they can judge visually what satisfies the request; reading a description is often not enough. Read `${CLAUDE_PLUGIN_ROOT}/references/variations.md` for how to build variations in context on the theme and how to deliver them for review.

# Step 3: Build

**Before starting, make sure you know exactly which template and, where relevant, which product you are building on.** The theme itself comes from AGENTS.md. If the user has not named the template or product, and nothing in the project says which to use, ask. Do not assume. If the working theme is the live theme, say so before you change it.

Once the user has picked a method from your suggestions, build inside the target theme and template. Name every section and block you place, as described in the store-editing reference, so the editor's sidebar says what it is and where it sits. If the method creates new files or changes shipped Sugar files, log them in the project's `custom-sections-blocks.md` when you are done.

# Step 4: Verification

Once the section or component is on the theme, verify that it looks and works properly. Open the page's preview so you see it the way a live customer would. Click around to test its functionality. Check both viewports, in both Chrome and Safari using the two headless browsers installed by setup; desktop may look right while mobile has bugs.

If the build has any bugs or visual quirks, diagnose the cause, fix it and test again. The task is not complete until the delivery looks polished and is fully functional.

# Step 5: Delivery & Revisions

After reviewing the build thoroughly, deliver it with clear, concise instructions on how and where to review it: a theme editor deep link to the exact theme and page, so the user can see the full page and adjust things themselves. The user may request changes or improvements.

If variations were built, the user may ask for elements of several to be merged, or have new ideas from seeing them. Once a winner is chosen, move it into the real template and clean up the variations scaffold.
