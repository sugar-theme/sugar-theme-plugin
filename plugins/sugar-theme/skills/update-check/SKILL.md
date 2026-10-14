---
name: update-check
description: Check the Sugar plugin and the user's Sugar Theme for available updates, update the plugin when the user agrees, report which theme fixes and improvements apply to their copy, and merge the ones they choose while keeping their customizations. Use when the user asks to check for Sugar updates or to update the plugin, when they paste the prompt from the app's "Update from your zip" card, when a bug in a shipped Sugar file surfaces since a fix may already exist, or when the feedback skill sends you here first.
disable-model-invocation: false
---

# Overview

Sugar ships fixes and improvements by publishing a new build of the theme. This skill finds out which files of the user's copy are behind, tells them in plain words what changed, and brings in what they pick. Files they never changed are replaced; files they changed that Sugar also changed are merged three ways, keeping what their change does. It never touches their content: templates, section groups, `settings_data.json` and anything else the theme editor writes are the user's data and are left alone.

Every Sugar `.liquid`, `.js` and `.css` file names the release it started from on line 1: `{%- comment -%}sugar:blocks/offers.liquid@2.0.0{%- endcomment -%}` or `/* sugar:assets/offers.js@2.0.1 */`. Only Sugar's own files change it: a release replaces it, and a three-way merge brings Sugar's line in with the rest. Never write or edit that line by hand, and never copy it into a file you create. It says where a file started, not that it is unedited: the check compares fingerprints to know that.

# Step 0: The plugin

Check the plugin first; it is quick and needs nothing from the store. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/plugin-update.sh check`. It compares the installed plugin with the latest release on GitHub and, when this copy is behind, prints the changelog entries it is missing.

- `status=current`: say in one line that the plugin is up to date.
- `status=behind`: tell the user what the newer version changes, from those entries, in plain words, and point out any **To do**. Ask whether to update now; never update without that yes. On a yes, run it with `apply`. It replaces only the plugin's own files, so the app's Update button isn't needed. Tell them the new version takes effect in their next conversation.
- `status=unknown`: GitHub couldn't be reached; say so and move on to the theme.

The Claude app's own plugin menu may keep showing the older number after this. That is expected: the files are current, and a later update from the menu simply installs the same release again.

# Prerequisites

- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first. **When the user pasted the prompt from the app's "Update from your zip" card**, the theme to update is the one they just uploaded, not necessarily the working theme; ask which one it is if the prompt and the theme list don't make it obvious.
- **The Sugar Theme MCP**, connected during setup. `check_theme_updates` gives this check its links, and `search_theme_updates` finds a published fix by its symptom.

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. This skill is the one case that pulls the whole theme, because every code file has to be compared. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

**If you came here because of a bug**, look for a published fix two ways before anyone writes a new one:

1. Read line 1 of the file the bug lives in, and of the snippets and scripts it uses. Call `search_theme_updates` with `file` set to that path and `since_version` to the release the stamp names: it lists every change Sugar made to the file after the copy the user has.
2. Call it again with the symptom as `text` ("FAQ tooltips cut off on iPhone"), which also finds a fix that landed in another file.

If a change matches, tell the user a proven fix exists, then carry on below to bring it in. If the file has had no change since its release, the cause is in the store's copy (an edit, a setting, an app) or a new bug.

# Step 1: Pull

Pull the theme in full into the scratch folder. The theme editor rewrites templates and settings constantly, so a copy from an earlier task is stale; pull fresh even if one exists.

# Step 2: Check

Call `check_theme_updates`. It returns a check link and a files link, both good for an hour. Run:

```
node "${CLAUDE_PLUGIN_ROOT}/scripts/theme-updates.js" check <theme folder> --check-url "<check_url>" --files-url "<files_url>"
```

Add `--base <build>` when the user's prompt from the app names one ("base build 577ae28"). After the app's zip update their untouched files already match the latest, so the check can't tell from them which build their changed files started from; without it those files read as needing nothing.

The script sends fingerprints and line-1 stamps, never the files. A changed file stamped with a different release than the rest of the theme (one fix brought in earlier on its own) is merged from the release its stamp names. It writes everything to `<theme folder>.sugar-update/`, beside the theme so a push never picks it up:

- `plan.json`: the build the theme came from and the latest, then each file's fate. `replace` (untouched, behind), `add` (new in Sugar), `protectedReplaced` (changed, but protected: always replaced whole, never merged, because merging them line by line is how they quietly stop working), `merge` (changed by the user and by Sugar), `keep` (changed by the user, unchanged by Sugar since: nothing to do), `own` (the user's own files), `retired` (untouched files Sugar no longer ships; left in place), and `changes`, newest first.
- `merged/`: each merge file already merged three ways, Liquid, JS and CSS with git's merge (conflicts marked `<<<<<<< yours` / `>>>>>>> sugar`), JSON key by key. `merge-report.json` says which merged cleanly, which conflict and which need a hand merge. `base/` and `latest/` hold the two originals.

Read the project's `custom-sections-blocks.md` as well. Its changes table says which shipped files an agent edited and why, which is what you need to merge them without losing the reason.

# Step 3: Report

Tell the user, in words a store owner understands:

- What changed in Sugar since their theme's build, from `changes`, newest first.
- How many files the update replaces and adds, and which of their changed files it merges. Name those files and what their change was for, when the log says.
- Any protected file being replaced whole although it was changed, and why.

If nothing is behind, say the theme is on the latest Sugar and stop.

# Step 4: Choose

The user picks: everything, or only the replacements and additions with the merges left for later. Use the AskUserQuestion tool (or your agent's equivalent). Recommend everything: a merge left out keeps an old file next to new ones.

# Step 5: Apply

- **Replacements, protected files and new files:** `node "${CLAUDE_PLUGIN_ROOT}/scripts/theme-updates.js" apply <theme folder>`. It writes them into the theme and lists them in `.sugar-update/changed.txt`.
- **Merges:** for each file in `merge-report.json`, review `merged/<path>` against what the user's change was for. A clean merge still gets a read; a conflict is resolved by keeping what their change does and bringing in Sugar's fix around it. Line 1 of the merged file is Sugar's latest stamp; keep it, and in a conflict on that line take Sugar's side. Show the user any part you were unsure about before writing it. Then copy the file into the theme. A file marked for a hand merge is compared with `latest/` by hand the same way.

Never blindly merge. A change can conflict with something the user's store relies on; when it does, say so and let them decide.

# Step 6: Push

Push only the files you wrote: the ones in `changed.txt` plus the merged ones, each written out with `--only`, following the working-theme policy. Then delete the scratch folder and its `.sugar-update` folder.

**One exception.** If the theme is the live theme (AGENTS.md says `Live edits: yes`) and the update replaces a protected file, duplicate the live theme first and push there instead. Tell the user why: that is the one update they should look at before customers see it. Record the duplicate's ID in AGENTS.md as the working theme for the review.

# Step 7: Verify and deliver

Open the pages the changes affect in both viewports and both browsers, and confirm the fixes show and nothing around them regressed, the merged files' features above all. Deliver a theme editor deep link to the theme and the pages to check, with a short list of what changed. The user reviews in the editor and publishes when ready, or asks you to.

# Additional Updates

If you came here because a bug surfaced in one Sugar file, the check shows every other file that is behind too, so you can proactively bring in fixes and avoid the next issue. Offer them; don't apply them unasked.
