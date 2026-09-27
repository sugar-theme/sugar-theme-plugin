---
name: enhance
description: Improve the design and/or functionality of a specific component, section or entire page. Use when the user already has a block, section or page on their theme and wants it improved rather than replaced or rebuilt. Not for creating something the page doesn't have yet; that is build.
disable-model-invocation: false
---

# Overview

Analyze an existing section, block or page on the user's theme and improve it, either by reworking it or by adding the smaller enhancements that make it feel more premium and high quality.

# Prerequisites

- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first.
- **The thing to enhance:** the template and, where relevant, the product, plus which section or block on it. If the user names only a page, confirm whether they mean the whole page or a part of it.

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 1: Analyze & Plan

Look at the user's section, block or page in its entirety. Read its template from the working theme so you see exactly which components and settings it is built from, and read the theme's brand settings so your suggestions stay in the user's type and colors. Analyze the goal it is trying to accomplish and its current gaps. Most users invoke this skill because the design isn't visually pleasing enough: it doesn't feel premium or unique, it feels unbranded, or it won't "wow" a visitor.

## Enhancement Ideas

Below are some suggestions on what makes a section or block feel more premium. Often they are minor improvements, usually to do with media or details.

- Background design (images, gradients, shaders, grids, meshes, etc.)
- Text accents and/or animations (color highlights, underlines, typing animations, etc.)
- Cutout images (images with transparent backgrounds go a long way). Offer to create the images an enhancement needs with an image tool the user has connected, such as the Higgsfield MCP or a similar generator, or to cut out and reuse ones they already have; the user can also defer the images and take the enhancement without them for now
- Subtle animations (tasteful hover, click or passive animations, color highlights, etc.)
- Information display: tooltips, popups or brand new components that display more information about a particular claim or concept
- Surrounding components: in some cases an enhancement depends on the surrounding components, or even the whole page's design and functionality. Consider them when deliberating.

This is not an exhaustive list; it is a set of suggestions for the small things that make an existing component more premium. Always think outside the box about how that particular component could be improved.

### Taste & Out of the Box Thinking

Be tasteful. Your enhancements shouldn't look like a junior dev who just learned about web design threw everything they've learned into the code. They should be intentional improvements for that context, with conversions in mind.

A lot of the design patterns in your training data come from general web and SaaS design. Some of them could be genuinely great additions to an Ecommerce store precisely because they aren't typical of existing stores. Your job is to discern which are visually pleasing while still being functional, fast, compact and optimized for conversions.

### Complete Reworks

In some cases a more significant rework makes more sense than a cosmetic touch-up: a component that would be displayed better in a different layout or with different functionality. Say so when that is the honest answer.

### Mobile First

Most Ecommerce traffic is on mobile devices. Make sure your enhancements are mobile friendly.

### Branding Considerations

Consider the other components on the page as well as the user's branding, product and target audience. Make sure your enhancements don't look out of place, and if they do, offer to enhance the rest of the page to match.

### Performance Considerations

Because traffic is mostly mobile and the goal is direct response, consider the performance impact of every enhancement. Most Ecommerce stores rely on low bounce rates and fast pages for a healthy return on ad spend. Some improvements come with a speed trade-off the user should know about. Don't avoid an enhancement just because it carries a cost; be transparent about it, and deliver it as optimized as it can be.

### Existing Files vs New Files

An enhancement can usually be made with the component's own settings, a Custom Liquid tweak, or an edit to the file. Sometimes it needs a new file. Read `${CLAUDE_PLUGIN_ROOT}/references/creation-methods.md` to pick the method with the smallest blast radius that still delivers the improvement, and tell the user which you chose. Changing a shipped Sugar file affects every page that uses it, so say so when that is the method.

# Step 2: Suggest

After analyzing the request and deciding which enhancements would make the biggest difference, present several options with the AskUserQuestion tool (or your agent's equivalent). The user may want to see all of them built so they can decide between them or combine elements of each. Read `${CLAUDE_PLUGIN_ROOT}/references/variations.md` for how to build variations in context on the page and deliver them for review.

# Step 3: Build & Verify

Once the user has chosen an enhancement or several, build them. Name every section and block you place, as described in the store-editing reference, so the editor's sidebar says what it is and where it sits. If the method is the live theme, say so before you change it. If it creates new files or changes shipped Sugar files, log them in the project's `custom-sections-blocks.md` when you are done.

Then verify that the enhancements look and work properly. Open the page's preview so you see it the way a live customer would. Click around to test the functionality. Check both viewports, in both Chrome and Safari using the two headless browsers installed by setup; desktop may look right while mobile has bugs. Compare against how the component looked before, so the improvement is real and nothing around it regressed.

If the build has any bugs or visual quirks, diagnose the cause, fix it and test again. The task is not complete until the delivery looks polished and is fully functional.

# Step 4: Delivery & Revisions

After reviewing the enhancements thoroughly, deliver them with clear, concise instructions on how and where to review them: a theme editor deep link to the exact theme and page, so the user can see the full page and adjust things themselves. The user may request changes or improvements.

If variations were built, the user may ask for elements of several to be merged, or have new ideas from seeing them. Once a winner is chosen, move it into the real template and clean up the variations scaffold.
