---
name: speed-optimization
description: Measure the speed of a page on the user's theme, read the results, suggest performance improvements ranked by impact and risk, and implement the ones the user picks. Use when the user asks why a page is slow, wants a better speed score, or asks to optimize performance.
disable-model-invocation: false
---

# Goal

Analyze a template on the user's theme, relentlessly and aggressively looking for optimization opportunities: starting with basic, low-risk tactics like compressing images and videos, then moving on to more drastic changes to the underlying files and code that make the page faster without breaking anything.

# Plugin version

Once per conversation, before the first step: run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/plugin-update.sh check`. If it prints `status=current` or `status=unknown`, say nothing and go on. If it prints `status=behind`, tell the user in a sentence or two what the newer Sugar plugin changes, from the changelog lines it prints (point out any **To do**), and ask whether to update now. Never update without that yes. On a yes, run the same script with `apply`, tell them the new version takes effect in their next conversation, and carry on with their request in this one.

# Prerequisites

- **Working theme** from the project's AGENTS.md. If it is missing, run `/sugar-theme:setup` first.
- **A page to test:** the template and, for a product page, the product. If the user doesn't provide one, ask.

Files are read from and written to the store as described in `${CLAUDE_PLUGIN_ROOT}/references/store-editing.md`. (`${CLAUDE_PLUGIN_ROOT}` is the plugin's root folder, two levels above this skill file, for an agent that does not fill the variable in.)

# Step 1: Testing

Measure the page two ways:

- **Lighthouse, run locally** through Google Chrome, or the headless Chromium setup installed when Chrome isn't on the computer (the first line of the command below picks it). It needs no key, works on the unpublished working theme, and is what you use to compare before and after.
- **Google PageSpeed Insights** as the second opinion, since it is what the user and their competitors look at. It only reaches the live theme, and it can't get past a storefront password.

Lighthouse can't type a storefront password, and a preview link redirects on every run. So first get a cookie that holds both the unlock and the working theme:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/lighthouse-headers.sh STORE.myshopify.com THEME_ID
```

It prints `host=`, `headers=` (a file) and `chrome=`, and stops with a plain reason if the password is refused or the store isn't serving the working theme. `chrome=` names the headless Chromium to run Lighthouse in when Google Chrome isn't installed; when it is empty, leave out the `CHROME_PATH` part below. Then run Lighthouse in mobile mode with real throttling on the plain page address on that host, with `pb=0` to hide Shopify's preview bar (about 420 KB shoppers never download, competing with the main image):

```bash
CHROME_PATH="CHROME" npx lighthouse "https://HOST/products/HANDLE?pb=0" --extra-headers=HEADERS_FILE --preset=perf --form-factor=mobile --throttling-method=devtools --output=json --output-path=./lighthouse-1.json --chrome-flags="--headless=new"
```

Check each report's final address is the page you meant, not `/password`. Make a fresh headers file for the after runs, and delete both when done.

Do not use the default simulated throttling. It hides how much the page's downloads compete with each other, and the same page can score far higher simulated than it does on a real slow connection.

The Shopify CLI can also profile how long the store takes to render the page's Liquid, which separates a slow theme from slow hosting:

```bash
shopify theme profile --store STORE.myshopify.com --theme THEME_ID --url /products/HANDLE
```

## Multiple Tests

Web performance is volatile and a single run can be a fluke. Run each test at least three times and use the median, not the best run. Keep the runs so the same numbers can be compared after the changes.

# Step 2: Analyze & Rank

Analyze the results thoroughly and document every potential improvement. Beyond the report's own audits, look at the things that most often slow a Sugar store:

- Images and videos that are larger, heavier or a worse format than the space they fill, and video posters or autoplay media above the fold competing with the hero image
- Third-party apps and scripts loaded on every page whether the page uses them or not
- Extra font families, including a custom or Accent font the page doesn't need
- Custom Liquid blocks carrying scripts or styles that could be a setting
- Layout shift: anything that moves or appears after the first paint
- Sections or blocks the page carries but never shows

Check where the hero sits. The theme loads the pictures of only the page's first two content sections up front; everything from the third section on waits its turn, so a hero there paints far later (about twice as slow on a test page). The header, announcement bars, Page Styles, Page Background, Hide Header & Footer, a Custom Liquid with no padding that holds only styles or scripts, and a floating or one-row Sticky Navigation take no place. If thin strips, logo rows or Custom Liquid sections push the hero to third or later, recommend one of these: turn a one-line strip into an Announcement Bar section, since it takes no place; merge code-only Custom Liquid sections into one with zero padding; or move the hero up. Tell the user in plain words why: only the first two sections load their pictures first.

Rank every optimization by highest impact and lowest blast radius, meaning how much of the store's look and functionality it could change, and how many pages it touches.

# Step 3: Suggest & Decide

Present the optimizations to the user in that ranked order, offering first to make the changes least likely to affect their store's look or functionality, such as compressing images and videos.

Use the AskUserQuestion tool (or your agent's equivalent) so the user picks the optimizations they want. Be transparent about each one so they understand the trade-offs, especially when a change touches files that affect pages beyond this one, or removes an app they may rely on. Do not be overly cautious; trust your skill and expertise.

# Step 4: Optimize & Verify

Implement the chosen changes. Compress videos with `bash ${CLAUDE_PLUGIN_ROOT}/scripts/video.sh web VIDEO` (the store's video address works as VIDEO): `--width` at about twice the width the video fills on screen, no sound unless it plays with sound, and the poster it saves as the video's cover image. Look at the result with `video.sh frames` before swapping it in, so a softer picture is caught before the user sees it. For media, upload the optimized files to the store's Files and point the settings at them rather than keeping anything locally. For shipped Sugar files you edit, log the change in the project's `custom-sections-blocks.md`; a theme update would otherwise overwrite it.

Then verify twice:

1. **Speed.** Run the same Lighthouse measurement again, three runs, and compare the medians with the before numbers. Report both to the user; a change that didn't move the numbers gets said plainly.
2. **Look and function.** Open the page in both viewports and both browsers and confirm it looks and works the way it did before. Test every component the changes touched for regressions.

Deliver with a theme editor deep link to the page and the before-and-after numbers. Ask the user to spot-check the parts they know best.
