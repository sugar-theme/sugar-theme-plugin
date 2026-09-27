# New file creation

How to create new section, block, asset and snippet files on a user's Sugar Theme so they behave like the rest of the theme: editable the way the user expects, fast, and findable by the next agent.

# Sections

When creating a new section, decide whether it will use theme blocks or section blocks. **You cannot combine both in one section.**

## Theme blocks

**Pros**

1. Reuse the blocks already in the theme. (You can also copy a theme block's code into a section block and amend it.)
2. Nesting: a List Item child inside an Icon + Text List parent, for example. Only theme blocks nest.

**Cons**

1. If the section needs new blocks of its own, they count against Shopify's limit of 300 theme blocks per theme.
2. Editing can be more complex for the user because of nesting levels and allowlists.
3. The section tends to be larger in the template, since versatile blocks write every one of their settings into it.

## Section blocks

**Pros**

1. No 300-block limit. The limit is 50 blocks per section.
2. Focused blocks with settings specific to the section's purpose, which means a smaller template footprint and simpler editing.
3. A section with a single block type is the most pleasant to edit: one click adds another of the thing (a Listicle section with a Reason block).

**Cons**

1. The blocks can't be used in other sections unless they are ported to theme blocks or to the other section's block set.
2. Less versatility in the editor, and no nesting.

**In most cases, opt for section blocks.** Sugar already ships versatile layout sections like Custom Columns that give a high degree of flexibility with theme blocks. A new section is usually created when too many Custom Columns sections would push a template toward the 512 KB limit, when the available blocks don't have the desired design or functionality, or when the user simply wants a simpler editing experience.

## Section allowlist

The theme has four section groups: Header, Template, Email Popups and Footer. Scope a new section to the Template group only, unless it genuinely belongs elsewhere; this keeps each group's "Add section" list relevant.

Sections can also be scoped to template types. Product-only sections exist only on product templates; Custom Columns is available everywhere. Most new sections can be added to all page types, but it is a judgement call based on what the section is for.

## Section best practices

Keep settings that affect several blocks at the section level, colors, positioning, text sizes, behaviour, instead of making the user change them block by block. Keep the variable content, the actual text, the image or video, in the blocks. Do this intelligently: sometimes a color, a position or a text size should live in the block. The goal is a focused, seamless editing experience with a lean schema, and it matters most in sections with section blocks.

# Blocks

When adding a theme block, decide where it should be addable and update those allowlists. Sugar is a block-focused theme: to make a block available inside Custom Columns, add it to the **Column** block's allowlist, not the section's. Consider the other wrapper blocks where it could be useful (Container, Row, Slide, and so on). It is worth asking the user, with the AskUserQuestion tool (or your agent's equivalent), where they want the block to appear. Make sure it works in each context you add it to.

# File and category naming

For sections and blocks alike, choose clear, straightforward names that say what the component does, so a person or another agent understands it at a glance. Abstract names cost the next agent a file read.

Two files must have distinct file names, though the user-facing name in the editor can repeat across files. Clarity and distinction still matter there.

Every section and block sits in a category in the editor's add menu. If a category already exists where the component belongs, use it; otherwise create one. A block with no category floats to the top of the list, which may be what the user wants. The category goes inside the block's `presets` entry, not at the top level of the schema; at the top level the upload is rejected.

Ask the user for the name and category, since both are what they will see in the editor. The names of assets and snippets are your call, but keep them clear for whoever reads the code next.

# Assets and snippets

Put a new component's static CSS in its own asset file (`assets/section-<name>.css` or `assets/block-<name>.css`) and load it from the file where its markup begins. The browser fetches the sheet once however many instances are on the page, and pages that don't use the component never load it. Do not use a `{% stylesheet %}` tag: Shopify compiles every one of those in the theme into a single stylesheet served on every page, so each new one slows every page of the store, not just the page that uses it. Setting-driven values go on the root element's inline style as custom properties, so the stylesheet stays static.

Consider a snippet when the same markup will be rendered by several files. Don't add an asset or snippet that duplicates one the theme already has; too many files that do the same thing is its own kind of bloat.

# Common settings to include

Use the theme's setting conventions wherever they apply, unless the user asks for something different or you leave a setting out on purpose to keep the schema lean. Every setting a file declares is written into the template for every instance, defaults included, which is how templates grow toward the 512 KB limit. A setting the user will rarely touch costs the same as one they will use every day.

## 1. Global theme settings

Customizations set once in theme settings, which new files should read rather than re-ask:

- **Corner rounding.** Four values, for media, containers, badges and buttons. Read the matching one. A per-component override is a single text setting with no default, labelled "Corner rounding", where blank means the theme value, `0` means square and `999` means a pill.
- **Color schemes.** Background, an optional background gradient, text and accent, set together. Sections and containers pick a scheme; a new component reads the scheme's colors so it follows whichever surface it sits on.
- **Palette.** The theme ships two swatches, the brand color and the accent, which code can reference as defaults. Swatches the user adds are editor-only and can't be referenced from code.
- **Buttons.** Primary, Secondary and Outline, each with its own colors. A new button reads one of the three.
- **Logos.** Primary and secondary.
- **Page width.** How wide content stretches in a section.

Read these with reasonable defaults for the context (a light scheme for a section, a dark one for a badge) and give the user an escape hatch: a color picker with no default, where empty means "inherit from the scheme" and a chosen color overrides. Never add a "color type: scheme or custom" select; the empty picker is the switch.

## 2. Common setting patterns

Settings the user is used to from editing the rest of the theme.

**Media.** Where an image can go, a video usually can too. Provide both an image picker and a video picker; when both are set, the video wins. No "image or video" select. Videos autoplay muted. Some places only make sense for one: an icon input takes an image; a full player takes a video.

**Icons.** One text input labelled "Icon", taking a token from https://sugarthe.me/icons (`check_circle`, `⭐️`, `1-circle`), rendered through the theme's icon snippet, plus an optional image picker that overrides it where uploads make sense. No icon-type selects and no "show icon" toggle; a blank token means no icon.

**Font options.** The user sets a Heading, a Body and an optional Accent font in theme settings. A font select on a new file offers all three roles or none; a select that offers Heading and Body without Accent is a bug. Many texts don't need a select at all (body copy is body), so add one only where the choice is real. A custom-font escape hatch forces an extra download on every page that uses it; avoid it unless the user asks, and point them at the Page Styles section, which can override fonts for one template more cheaply.

**Typography settings.** Beyond the font role: font weight, text size, line height and letter spacing. Font weight is always a slider from 100 to 900 in steps of 100. Text size and weight are the two the user reaches for; line height and letter spacing are niche. In the theme these mostly live on the Typography child block, but a section with section blocks can't use it, so put the ones that matter in the section or its blocks. Add them intelligently; printed on every instance, they bloat the template.

**Text and icon vertical centering.** Text inside a container such as a badge sits low because its line height adds space below. If the text won't wrap in that context, set its line height to 1 to center it. Optical centering still varies by font and layout, so spot-check once it is built.

**Margins.** Blocks have a top and bottom margin, `0px` top and `6px` bottom by default, on a `0` to `50` slider in `1px` steps. A new theme block must have them, or the user can't space it among the existing blocks without hassle. For section blocks a single gap setting at the section level is often better, since fine-tuning per block isn't needed. Your call by context.

**Padding.** Sections expose top and bottom padding so the space between sections can be tuned; the theme's range is `0` to `100`, `1px` steps. On containers and badges, vertical and horizontal padding are useful and cheap; the component range is `0` to `60`.

**Per-viewport values.** Sizes often differ by viewport, so the theme's blocks expose desktop and mobile values for things like text size. A mobile alignment setting is a select whose first option is "Same as desktop", the default. Layout can also change by viewport, though that is rarer. When cloning, stay true to the reference's behaviour on each viewport.

**Starting values when cloning.** Start at the reference's values.

**Anchor ID.** Sugar has blocks that scroll to or deep-link to a section or block. An Anchor ID setting is cheap on a section and worth adding on a block only when it is likely to be a scroll target, like the Offer blocks.

**Custom Liquid.** A Custom Liquid input on a section is cheap and lets a future task adjust that one placement without editing the file. Almost never on a block: the scope it could target is tiny and it adds a setting for little benefit.

# A reasonable, organized schema

Organize the settings into headers so the user can find things. Beyond the patterns above, think about which other settings the context calls for. The file should be very editable on its own without feeling cluttered or complex.

Three platform rules that fail silently or reject the upload:

- Conditional visibility (`visible_if`) supports `==`, `!=`, `and` and `or`. It does not support `>=`, `<=` or parentheses, and an expression over 250 characters is rejected. A bad expression rejects the whole schema with no clear error. Product, collection, page, blog and article pickers can't be conditional at all.
- A range value in a template must sit inside its setting's min and max and on its step, and every nested block type must be in its parent's allowlist. An invalid value doesn't error; the template silently breaks.
- The theme hides empty `div` elements globally. A decorative element with no content (a progress bar, a spacer) needs `display: block` set explicitly or it disappears.

# Leveraging existing Sugar features

To preserve the theme's functionality and speed, and to let the user customize a new component the way they do everywhere else, link new files to existing Sugar features where they fit: the pricing scripts, the slider and accordion engines, the icon token system, the color schemes and the typography variables. Some tasks need a different architecture; adopt existing features intelligently, not reflexively.

# Speed

Always consider the impact of new files on the store's speed. Choose the leanest architecture that still looks, feels and performs well. Concretely: static CSS in the component's own asset, no per-instance `<style>` or `<script>` that could be one shared thing, images lazy-loaded below the fold with the width they render at, and nothing that hides or moves visible content after the page first paints.

# Logging the file

Once the file exists, log it in the project's `custom-sections-blocks.md`: what it does, what it was based on, what it depends on, where it is allowed, when to use it and any best practices. Future agents find it there instead of building it again.

# High-converting Ecommerce principles

Your training data on web design covers the whole internet, and only a small part of it is Ecommerce, let alone Ecommerce built for conversions.

## Mobile first

Most Ecommerce traffic is on mobile. Optimize for that viewport first: compact, legible, and a good overall experience. Then make desktop earn its extra space.

## Deslopification

Avoid the patterns that mark a design as generated:

- Mono text accents (especially JetBrains Mono). Use only the user's fonts from the theme, and offer an Accent font if the task calls for one.
- Excessive eyebrow text, especially with status chips. Eyebrows are useful; add them tastefully.
- Hover effects on everything.
- "Fingernail" callouts.
- Text and components that clip outside their container and look sloppy.

## Out of the box thinking

A new file usually exists because no existing component satisfied the request, and the existing components already cover most top-converting Ecommerce designs. So to wow the user and, more importantly, to convert, create designs and layouts that are genuinely new: not for artistic expression or a good first impression, but because they sell.
