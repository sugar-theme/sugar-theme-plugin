---
name: clone
description: Clone a component, section or entire page that the user links or references. Use when the user provides a page URL, a screenshot, or tags an element in the built-in browser and wants that component on their store.
disable-model-invocation: false
---

# Overview

Create blocks and sections inside the user's Sugar Theme that match a reference: a URL, a screenshot, or an element the user tagged in the built-in browser.

# Prerequisites

- **Sugar Theme** installed on the user's Shopify store.
- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first.
- **Target template and product** named by the user, so you know where the clone goes and whether it should be linked to a particular product.
- **A reference:** a screenshot, a page URL, or an element tagged in the built-in browser. Without one there is nothing to clone.

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 1: Analysis

Look at the screenshot and/or reference URL the user provided and analyze them thoroughly. On the reference page, locate the element the user asked for if they have not tagged it already. Extract its HTML and CSS in full, including the computed styles at both viewports, since a stylesheet rarely tells the whole story. If the component does not fully expose its code, reverse-engineer its design and functionality.

## Cloning Best Practices

To clone accurately, analyze the following aspects of the reference:

- Font sizes
- Font weights
- Line height
- Letter spacing
- Premature line breaks in headings
- Padding values, including asymmetric ones
- Page and content widths
- Row and column gaps
- Animation types and speed
- Viewport differences (below)

## Images

A reference tells you exactly which images the clone needs and how they are treated: a cut-out product on transparent background, a lifestyle photo behind text, a custom icon set, a portrait. List them in the analysis. Then offer to create them with an image tool the user has connected, such as the Higgsfield MCP or a similar generator, or to use images already in their store or on their computer. A clone with the right layout and the wrong pictures still looks wrong. Visuals never block the build, though: if the user wants to sort out images later, build the layout now and leave the picks for them.

In some cases, downloading and using the same image from the reference is fine. For example when it comes to an icon or a guarantee badge, assuming it fits the user's product & brand. In other cases, it can be used as a reference for generating a new image, so that the AI image model has a better starting point.

Icons follow a fixed order. First, match each icon in the reference to the Sugar icon library at https://sugarthe.me/icons (Material, Lucide, Phosphor, Heroicons, brand logos, emoji), which needs no file at all. If there is no match, download the reference's icon image. Only as a last resort draw it as SVG code and upload that as an image. Where the reference uses a short autoplay video, treat it like an image: reuse, recreate or defer.

## Reading a screenshot

When the only reference is a screenshot, or a detail is too small to read, use the plugin's zoom tool rather than guessing: `node ${CLAUDE_PLUGIN_ROOT}/scripts/zoom.js grid` overlays pixel coordinates so you can measure gaps and padding, and `crop` enlarges a region so borders, icon strokes and small type become legible. When the page is live, prefer the browser: an element screenshot at device scale 2 is sharper than any crop of a screenshot.

## Fonts

Use the user's fonts from the theme, never the reference's. The four typography aspects above still matter: adapt the reference's sizes, weights, line height and letter spacing intelligently to the user's heading and body fonts so the clone keeps its proportions in the user's type. Loading the reference's font family would add a download to every page it sits on and give the store a font its other components don't use; a user who wants that font would change it in the theme settings, not in one component.

## Viewport Differences

Many Ecommerce sections and blocks look and feel vastly different depending on the device's width. Some of the ways a component can differ across viewports:

- Different font and component sizes
- Different functionality (a grid on desktop, a slider on mobile)
- Different padding values
- Different margin, gap and spacing values
- Different alignment and positions

In some cases a component is exclusive to desktop or mobile, meaning it disappears or moves at a different breakpoint.

These are the common differences; the list is not exhaustive. Analyze and document how the reference renders at **749px and below**, the theme's mobile breakpoint, so the clone matches on both device types.

## Reference URL

If the user only provided a screenshot, kindly ask for a direct URL to the page or ask them to tag the element in the app's browser. Let them know that direct access to the live page allows for a far more accurate clone.

Use the reference URL and its code as the primary source of truth. The screenshot is a pointer to the component, not the spec.

If the user has no access to the page, continue to the best of your ability with the screenshot alone.

# Step 2: Method Selection

Decide which method, or methods, you will use to build the clone. Read `${CLAUDE_PLUGIN_ROOT}/references/creation-methods.md` to sort through the options, then give the user the recommended ones before starting. A clone rarely calls for variations, since the goal is to match one reference; offer them only if the user asks.

# Step 3: Clone

**Before starting, make sure you know exactly which template and, where relevant, which product the clone is for.** The theme itself comes from AGENTS.md. If the user has not named the template or product, and nothing in the project says which to use, ask. Do not assume. If the working theme is the live theme, say so before you change it.

Once the user has picked a method from your suggestions, build the clone in the target theme and template. Name every section and block you place, as described in the store-editing reference, so the editor's sidebar says what the clone is and where it sits. If the method creates new files or changes shipped Sugar files, log them in the project's `custom-sections-blocks.md` when you are done.

# Step 4: Verification

Once the clone is on the theme, verify that it looks exactly like the reference. Open the page's preview so you see it the way a live customer would. Compare it side by side with the reference **in both viewports and in both Chrome and Safari**, using the two headless browsers installed by setup.

Put the two next to each other rather than flipping between tabs: `node ${CLAUDE_PLUGIN_ROOT}/scripts/zoom.js side reference.png clone.png` joins them at the same width, and `crop` on both at the same box shows whether a padding or a border really matches.

This covers functionality as well as design. If the clone does not match, diagnose the gap, fix it and test again. The task is not complete until it looks exactly like the reference and is fully functional.

**Caveat:** if the chosen method has a known gap that prevents a 1:1 match, you can deliver after verifying basic design and functionality, as long as the user was told about the gap when they picked the method.

# Step 5: Delivery & Revisions

After reviewing the clone thoroughly, deliver it with clear, concise instructions on how and where to review it: a theme editor deep link to the exact theme and page, so the user can see the full page and adjust things themselves. The user may request changes or improvements.
