---
name: update-check
description: Check the user's Sugar Theme for available updates, report which fixes and improvements apply to their copy, and merge the ones they choose while keeping their customizations. Use when the user asks to check for Sugar updates, when a bug in a shipped Sugar file surfaces since a fix may already exist, or when the feedback skill sends you here first.
disable-model-invocation: false
---

# Overview

Sugar ships fixes and improvements as changes, not as whole-theme reinstalls. A change usually touches several files and comes with a title, the symptoms it fixes, and the exact diff. This skill finds out which changes the user's copy is missing, tells them in plain words, and applies the ones they pick. It never touches their content: templates, settings and anything the theme editor writes are the user's data and are left alone.

# Prerequisites

- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first.
- **The Sugar Theme MCP**, connected during setup. It provides the updates index, each change's page and diff, the original of any shipped file at any release, and a classifier that tells whether a file is untouched or customized.

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. This skill is the one case that pulls the whole theme, because every code file has to be classified. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 1: Pull

Pull the working theme in full into the scratch folder. The theme editor rewrites templates and settings constantly, so a copy from an earlier task is stale; pull fresh even if one exists.

# Step 2: Classify

Every shipped code file carries a stamp on its first line, `sugar:<path>@<release>`, naming the release it last changed in. Read the theme's own release number from `theme_version` in the settings schema. Then, for every code file, send its path and fingerprint to the MCP's classifier: it answers **untouched**, **customized** or **unknown**, with the release the file started from. Fingerprints are the truth; the stamp only tells you which original a customized file began as.

Read the project's `custom-sections-blocks.md` as well. Its changes table says which shipped files an agent edited and why, which is what you need to merge them without losing the reason.

# Step 3: Report

Ask the MCP for every change newer than the theme's release, and show the user the ones that apply to their copy: grouped by type, newest first, each with its title and the symptoms it fixes, in words a store owner understands. Hide changes recorded as already applied in the project's update ledger. Show a change whose requirements aren't met with what it needs first.

**If you came here because of a bug**, search the index by symptom first: "FAQ tooltips cut off on iPhone". If a change matches, tell the user a proven fix exists before anyone writes a new one.

# Step 4: Choose

The user picks: everything, a type, or specific changes. Use the AskUserQuestion tool (or your agent's equivalent). Recommend `security` and `protected` changes first, and say why.

# Step 5: Apply

Apply in dependency order:

- **Untouched files** are replaced with the new original.
- **Customized files** are merged three ways: the original the file started from, the new original, and the user's copy. Show the user any hunk you were unsure about before writing it, with what the customization was for, from the log.
- **Protected files** are replaced whole, never merged, even when customized. The report says so. These files carry the theme's integrity checks; merging them line by line is how they quietly stop working.
- **Migrations** that ship with a change run against the freshly pulled templates, since they are the only updates that touch merchant data, and only in the way the change describes.

Never blindly merge. A change can conflict with something the user's store relies on; when it does, say so and let them decide.

# Step 6: Record and push

Stamp each written file with its new release. Record the applied change ids in the project's update ledger, `sugar-updates.json`, next to `custom-sections-blocks.md`, so the next check doesn't offer them again. Raise `theme_version` once no file is behind the release it names.

Push only the files you changed to the working theme, following the working-theme policy. Then delete the scratch folder.

**One exception.** If the working theme is the live theme (AGENTS.md says `Live edits: yes`) and the chosen changes include `protected` or `security` ones, which replace whole files, duplicate the live theme first and push there instead. Tell the user why: that is the one update they should look at before customers see it. Record the duplicate's ID in AGENTS.md as the working theme for the review.

# Step 7: Verify and deliver

Open the pages the changes affect in both viewports and both browsers, and confirm the symptoms are gone and nothing around them regressed. Deliver a theme editor deep link to the theme and the pages to check, with a short list of what changed. The user reviews in the editor and publishes when ready, or asks you to.

# Additional Updates

If you came here because a bug surfaced in one Sugar file, check for updates to the other files too, so you can proactively bring in fixes and avoid the next issue. Offer them; don't apply them unasked.
