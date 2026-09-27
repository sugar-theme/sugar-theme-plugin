# Creation methods

The available ways to create pages, sections, blocks and features on a Sugar Theme. For each method: what it is, when to opt for it, and its pros, cons and limitations.

## Method Ranking

Methods are ordered by how much they lean on existing code with proven functionality and Ecommerce patterns, while preserving the theme's current features. The first method keeps the theme's files completely as they are and edits only the templates those files are arranged in; the last edits existing files in ways that can change the theme globally. Methods at the top aren't necessarily better. They have a smaller blast radius and are easier to reverse.

## Combining Methods

More than one method can be used to complete a task. Decide which method or methods make the most sense for the task; the user may also ask for a specific one.

## Your Goal

The goal is always to complete the user's request, not to be afraid of significant edits to the theme when the task requires them. When more than one method is viable, use the AskUserQuestion tool (or your agent's equivalent) and explain the benefits and downsides of each in the context of the task, so the user makes the final call.

## Where to look

- **Sugar's own sections and blocks** are listed in the plugin's catalog index, names and one-liners; the full docs for any component, including its settings and known issues, come from the Sugar Theme MCP.
- **Files created by other agents in this theme**, and shipped files they changed, are logged in the project's `custom-sections-blocks.md`. Read it before deciding a component doesn't exist.

# Available Methods

## Method 1: Existing Theme Files Only

Use one or more sections and blocks already on the theme, with only their available settings and features. This includes the Sugar Theme's own files and any files created earlier by agents in this theme.

**When to use:** existing files, with their available settings, can complete the job in its entirety.

**Pros:** no new files are created and existing ones stay untouched. The functionality is proven, the design is what the user is used to, and they can edit the result in the theme editor exactly as they always have.

**Cons:** Sugar's files are versatile, and versatility has a cost: every setting a file declares is written into the template, default values included. A template with many sections built only from Sugar files is therefore more liable to hit Shopify's 512 KB template limit, especially with many nested blocks. The densest pages are still under 300 KB, but it is a real consideration.

**Limitations:** existing files may not completely match what the user wants, especially in a cloning request. Always check first; the files are extremely versatile. If existing files get most of the way there but not all of it, combine this method with one below.

## Method 2: Existing Theme Files + Custom Liquid

Only existing files are used, as in Method 1, but the section's Custom Liquid input is used to target specific blocks, components and features and change their look or functionality for that one place.

**When to use:** existing files do almost all of the job and need only minor cosmetic or functional changes that the user is unlikely to need to edit later.

**Pros:** no new files, and existing files are unchanged, so their design and functionality elsewhere in the template and theme are unaffected.

**Cons:** Custom Liquid that targets another file has to be executed immaculately and tested thoroughly before delivery. In a JSON template the Custom Liquid is stored inside the template itself, so it counts against the 512 KB limit, more so when the template already carries Custom Liquid or the snippet is long.

**Limitations:** Custom Liquid isn't editable by a non-technical user in the theme editor; changing it means going back to their agent and understanding why a section or block behaves the way it does. A fine trade-off when it isn't a setting the user will need to change, and they know the customization's limits.

## Method 3: Custom Liquid Sections & Blocks

The theme's Custom Liquid section or block holds the entire build. For a whole section, use the Custom Liquid section. For a component inside an existing section that hosts theme blocks, use the Custom Liquid block. Inside a section that uses its own section blocks, prefer adding a new section block instead (Method 4), since section blocks don't count against Shopify's limit of 300 theme blocks.

**When to use:** the user wants a very simple section or block that won't need significant editing after creation, existing files don't come close to the desired design or functionality, and the user doesn't want a new file or an edit to an existing one.

**Pros:** no new files, and existing files are unchanged.

**Cons:** Custom Liquid can clash with fragile parts of the theme, especially complex scripts, which leads to silent regressions without an obvious cause. It carries the same 512 KB risk, since all of the code lives in the template. The user can copy and paste the code into another template to reuse it without an agent, but it is never an addable section or block in the editor.

**Limitations:** not editable by a non-technical user, and because these builds tend to be larger than a Method 2 tweak, even small changes mean a round trip to the agent. **This is the least useful method** for its effect on page functionality, the lack of editor customization, and its template bloat. It has its place for very focused builds, small blocks especially, or when the user asks for it. When suggesting it, make sure the user understands the limitations.

## Method 4: Completely New Files

New files are created inside the theme: sections, blocks, assets and/or snippets.

**When to use:** an existing file's design or functionality differs too much from the request and the new file is likely to be used more than once, or the user specifically asks for a new file.

**Pros:** complete freedom. You don't need to adhere to an existing file's design, functionality or settings; you can create anything to fulfil the request. The user can reuse the file anywhere in their theme, on their own in the editor or by asking their agent.

**Cons:** possible clashes with existing functionality, especially when scripts are involved or the file touches pricing, quantity, variants, subscriptions or similar. The file shows in the theme editor, and at volume that becomes clutter, though some users want exactly that. Agents suffer the same clutter differently: a theme full of files that seem to do the same thing, or have no clear purpose, gives future agents too many options when composing templates. For these reasons, name new files clearly and document them in the project's `custom-sections-blocks.md`. Follow `new-file-creation.md` for the rest.

**Limitations:** the fewest of any method. Shopify's own limits apply: 300 theme blocks per theme and 50 section blocks per section.

## Method 5: Edit Existing Files

The code inside a file that already exists in the theme is edited, to change its design or functionality or to add features on top of it.

**When to use:** the user wants to change the design or functionality of a component globally, without creating a new file.

**Pros:** existing code is tweaked rather than written from scratch, so most of its functionality and design survive and iteration is fast. Changes that are meant to affect the store's look everywhere are achieved exactly this way.

**Cons:** if the file is used elsewhere in the theme, it changes there too. Depending on the context that is the point, and matches the request. New settings added to the file's schema add to the template size everywhere the file is used, which matters only for a heavily used block. And a shipped Sugar file that has been edited is a file a theme update has to merge instead of replace, so every such edit must be logged (below).

**Limitations:** the second fewest. Extending an existing file adds no theme blocks, but a comprehensive section is still bound by the 50 section blocks limit, which is hard to hit in practice.

**Other considerations:** adding a new setting that is off by default is the best way to change a block's design or functionality without affecting the places it is already used. Changing a setting's type (a checkbox to a select, say) breaks the component everywhere it is already placed: the stored value is no longer valid, the component won't display, and the template may not even sync until it is amended. And when you significantly change a file, the Sugar docs that other agents read still describe the old one. That drift is why every significant change to an existing file is logged in `custom-sections-blocks.md`, just like a new file, so future agents know the new capabilities, don't edit the file again for the same reason, and the update-check skill knows what to preserve.

## Transparency & User Selection

Before building, tell the user which methods fit the task best. Use the AskUserQuestion tool (or your agent's equivalent) so they pick between them, with the benefits and trade-offs of each in the context of the task, and mark one as your recommendation. When the build is finished, remind them how it was built.
