---
name: variations
description: Build several distinct versions of a new or existing block, section or page, in place on the user's theme, and let the user flip between them on the real page before choosing one. Use when the user asks for more than one option, or for "variations", "a few directions" or "a couple of versions" of a build, freestyle or enhance task.
disable-model-invocation: false
---

# Overview

Variations are built on the theme, in context, in one file, so the user judges them where they will live and the winner is already built. Read `${CLAUDE_PLUGIN_ROOT}/references/variations.md` for exactly how to plan, scaffold, deliver and clean up variations. This skill adds nothing to that reference; it exists so a user can ask for variations directly. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Steps

1. Establish the task the variations serve, and its template and product, the way the build, freestyle or enhance skill would. The working theme comes from the project's AGENTS.md.
2. Follow the reference: ideate distinct directions, scaffold them on a copy of the target template with the switcher, verify each one, and deliver the editor deep link.
3. When the user picks a winner, move it into the real template and clean up the scaffold.
