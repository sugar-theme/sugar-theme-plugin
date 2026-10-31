# Sugar Theme: guide for agents

Sugar is a Shopify theme for high-converting Ecommerce stores, built from patterns used by top brands. This file is for any AI agent that edits the theme: Sidekick in Canvas, or a coding agent working on a local copy. It covers how Sugar is built, the conventions that keep a merchant's store editable and fast, and the mistakes earlier agents made. Read it before changing the theme.

- **Design intent lives in `DESIGN.md`** at the theme root: what each palette color and color scheme is for, font rules, and the merchant's dos and don'ts. Read it before design or styling work, and keep it current when the merchant states a lasting preference.
- **Full docs for every section and block** are at `https://app.sugarthe.me/docs/<sections|blocks>/<slug>.md` (plain text), indexed at `https://app.sugarthe.me/docs/index.md`. Read a component's page before using or changing it: it lists every setting and the blocks it accepts.
- **Agents with the Sugar plugin** get the same docs, plus known issues, through the Sugar Theme MCP. This file is the base contract either way.
- **This store's own components** are listed at the end of this file, under *Store additions*. Read them before building something new; it may already exist.

---

## Never break these

1. **Line 1 of every `.liquid`, `.js` and `.css` file is its release stamp** (`sugar:<path>@<release>`). Theme updates read it to tell the merchant's edits from Sugar's. Never edit, move or delete it. A new file needs no stamp.
2. **Keep `data-_sf="{{ block.id }}"`** (or `section.id`) on the root element of every section and block, next to `{{ block.shopify_attributes }}`. Scripts and stylesheets find a component's root through it. A new section or block carries it too.
3. **Setting ids, option values and block types are saved in the merchant's templates.** Renaming or removing one breaks every page that uses it, silently. Add new ones instead; change a label freely.
4. **A page template stops saving at 512 KB, and a theme holds at most 300 block files.** The editor writes every setting a block declares into the template for every instance, defaults included, so each new setting costs bytes on every page that uses the block. Sugar is close to the 300 cap: don't add a block file where a setting or a section block would do.
5. **Never use `{% stylesheet %}` or `{% javascript %}`.** Shopify's guides recommend `{% stylesheet %}` for its per-page CSS trimming, but that trimming only applies to themes installed from the Theme Store. Sugar is installed from a zip, so every such tag is compiled into one stylesheet that every page downloads before it shows anything (measured: per-file CSS paints 1 to 2 seconds sooner). Put CSS in the component's own asset (see *Styling*).
6. **A page that needs its own header or footer carries the Header and Footer sections in its template.** Never make a new layout or section group for it: Shopify allows 20 section groups per theme, and the theme leaves the store's own header and footer out of a page that has its own.

---

## How a Sugar page is built

### Sections: two kinds

**Layout sections** are blank canvases you compose from theme blocks. Reach for them when the design is custom.
- **Custom Columns** (`custom-columns`): columns on a 12-column grid, each a **Column** block holding any content blocks. The workhorse of the theme.
- **Split** (`split`): two sides at an exact ratio, each with its own colors running to the screen edge, plus full-width **Split Row** blocks.
- **Media with Text**, **Alternating Media + Text**, the three heroes (**Full Width Hero**, **Split Hero**, **Hero Carousel**), **Footer**.

**Purpose-built sections** do one job: comparison tables live as blocks, but reviews (`judgeme-reviews`, `okendo-reviews`, `yotpo-reviews`, `junip-reviews`), `faq`, `ingredient-cards`, `expert-cards`, `before-after-slider`, `study-table`, `stacked-cards`, `story-cards`, `hotspots`, `progress-tabs`, `as-seen-on` (press and partner logos, on most sales pages), the quiz sections, `email-popup`, `announcement-bar`, `sticky-product` and others.

**Prefer a purpose-built section when one exists for the job.** It has focused settings in one place, so the merchant edits it in a few clicks instead of opening nested blocks; it stores far fewer settings in the template (its section blocks carry only what that section needs); and its blocks don't count against the 300-block cap. Use a layout section when the design is genuinely custom or when the content mixes many kinds of blocks.

Every section has top and bottom padding, an Anchor ID (for scroll links and Sticky Navigation), and most have a width setting (default, full, custom). A section with a width setting must keep the page-width signal it already emits (`page-width` class, or `data-page-bg-width`), or the Page Background section stops constraining it.

### Blocks

- **Wrapper blocks** hold other blocks: Column, Container, Row, Double Column, Slider and Slide, Grid and Grid Item, Tabs, Timeline, Reveal Cards. **Content blocks** render something: Heading, Text, Media, Badge, Icon + Text List, Link Button, the product blocks, the comparison tables.
- **Sugar is block-first.** To make a block available in Custom Columns, add it to the **Column** block's `blocks` allowlist (and to Container, Row, Slide or others where it fits), not to the section. A block missing from its parent's allowlist silently breaks the template upload.
- **A section uses theme blocks (`@theme`) or its own section blocks, never both.** Section blocks are often the better choice for a new section: no 300-block cost, settings that fit the section, a smaller template, and "Add block" gives the merchant exactly the thing they want more of.
- **The product page** is the **Product Main** section with two static blocks, **Product Media** (gallery) and **Product Info** (buy box). Product blocks (Product Title, Product Price, Buy Button, Offers, Subscriptions, Variant Picker, Gift blocks, Product Subtotals) go inside Product Info, or inside a **Custom Buy Box** (`featured-product-info`) anywhere else on any page.
- **A parent can't read its children's settings or types.** Theme blocks report their type as `@theme` to their parent. When a parent needs to know about a child, it reads the child's rendered markup (a `data-` attribute or class the child prints). Route through markup, not through `block.blocks`.
- **Blocks are wrapped.** Shopify wraps each nested theme block in a `div.shopify-block` (unless its schema has `"tag": null`). A layout that expects blocks as direct children has to account for that wrapper.

### Layouts

- `theme` is the default. Product, collection and sales pages use it.
- `landing` is a stripped-down layout for ad, listicle, advertorial and pre-sell pages: no header, footer, cart drawer, popups or cart scripts. It can't hold anything that needs the cart: buy buttons, variant pickers, prices that change with quantity or variant, offers, subscriptions, upsells, gift pickers, sticky add-to-cart. Check a template's `"layout"` before adding one of those.

---

## Deciding what to build

Work down this list and stop at the first that does the job:

1. **Existing sections and blocks, configured.** Sugar covers most top-converting Ecommerce patterns; read the docs index first.
2. **Existing components plus a little Custom CSS** in the section's Custom CSS field (500 characters at most per section) or a Custom Liquid block for a small one-off.
3. **A new section with section blocks**, for a design no combination of existing blocks gives, or when many Custom Columns sections would push the template toward 512 KB.
4. **A new theme block**, only when it will be reused across sections, and never past the 300-block cap.

**Changing a shipped Sugar file is encouraged** whenever extending it beats building something new: a new option, a new setting, a design change the merchant wants everywhere. Merchants are meant to build on Sugar's files and make the theme their own. What to watch is the blast radius, because the file is probably used on other pages:

- Find every template and section group that uses it (search `templates/*.json` and `sections/*.json` for its type) and check how the change lands on each.
- Add a new setting rather than changing what an existing one does; a new behavior that is off by default leaves every existing placement as it was.
- Never change a setting's type or remove an option value: stored values stop being valid and the component stops rendering where it is already placed.
- Record the change under *Store additions*, with what and why, so a theme update merges Sugar's fixes into it instead of replacing it.

A new section is offered only on the template types it makes sense on (`"enabled_on": { "templates": ["page"] }`, product-only sections only on product templates) unless it genuinely belongs in the Header, Footer or Email Popups group. Never write `"enabled_on": { "groups": ["template"] }`: Shopify accepts only `header`, `footer`, `aside` or `custom.<name>` there and rejects the section on upload. Keep settings that affect every block (colors, positions, text sizes, behavior) on the section, and the content that varies (text, images, video) on the blocks.

Name files and components plainly by what they do. Put a new section or block in an existing editor category if one fits (`"category"` goes inside the `presets` entry, never at the top of the schema, or the upload is rejected).

---

## Settings, the Sugar way

Merchants learn these patterns once and expect them everywhere. Use them in every new or edited schema.

**Global theme settings to read, never re-ask:** color schemes (background, optional gradient, text, accent), the color palette, four corner radii (media, container, badge, button), three font roles (Heading, Body, optional Accent), Primary / Secondary / Outline buttons, logos, page width.

- **Corners:** one `text` setting labelled "Corner rounding", no default, info "Empty = theme corners". Blank inherits the theme value, a number is px (`0` square, `999` pill). Never a number setting (a cleared number stores 0) and never a mode select.
- **Colors:** a `color` picker with no default, where empty means "follow the color scheme", plus an optional `color_background` for a gradient. Never a "color type: scheme / custom" select. Precedence: gradient, then solid, then scheme.
- **Icons:** one `text` setting labelled "Icon" taking a token from https://app.sugarthe.me/icons (`check_circle`, `star-600-fill`, `⭐️`, `1-circle`), rendered with `{% render 'icon', name: …, size: … %}`, plus an optional `image_picker` that overrides it. No icon-type selects, no "show icon" toggle: a blank token means no icon. Never guess a token; copy it from the icon page. Material icons have no separate filled drawing for many glyphs, so don't add `-fill` unless the icon page shows it.
- **Fonts:** a font select offers `heading`, `body` and `accent`, or isn't there. Offering Heading and Body without Accent is a bug. Most text doesn't need a select at all.
- **Font weight:** always a `range` from 100 to 900 in steps of 100, emitted straight into CSS. Heading roles default to `var(--font-heading-weight)` or `var(--font-body-weight-bold)`, never a hard number.
- **Margins:** blocks have Top margin and Bottom margin, `0` to `50`, step 1, px, defaults `0` and `6`.
- **Padding:** section band padding `0` to `100`; component padding `0` to `60`. Step 1, minimum 0.
- **Desktop and mobile:** sizes come in desktop/mobile pairs; keep both. A mobile alignment setting is a `select` whose first option is `same` / "Same as desktop", the default. Never Shopify's `text_alignment` type for the mobile half.
- **Media:** where an image can go, a video usually can too. Offer both pickers; when both are set, the video wins. No "image or video" select.
- **Five or six settings per header, at most.** Split by what the merchant is doing (`Text`, `Rows`, `Icons`), never a `Settings` or `Style` wall. A header whose settings share a `visible_if` carries it too, so the editor never shows an empty heading. Moving settings under new headers changes no ids and breaks nothing.
- **Typography settings:** text size and weight are the two a merchant reaches for; line height and letter spacing are niche, so add them only where they matter. In the theme they mostly live on the **Typography** child block of Heading and Text; a section with section blocks can't use that, so put the ones that matter on the section or its blocks.
- **Text inside a pill or badge sits low** because its line height adds space below. If it won't wrap there, give it `line-height: 1`, then check it by eye: optical centering varies by font.
- **Anchor ID** on sections and on blocks a merchant would scroll to (Offers, FAQ, comparison tables, wrappers), not on every block.
- **A placeholder in an existing text setting often beats a new setting.** Sugar's text settings already understand bracket placeholders, and a new one costs no stored setting on any page and no extra control in the editor. Use the families that exist before inventing one, and list the placeholders a setting accepts in its `info` text, which is how merchants find them:
  - **Live values**, filled by Liquid and kept current by the pricing scripts: `[price]`, `[compare_price]`, `[amount]`, `[amount_rounded]`, `[percentage]`, `[quantity]`, `[price_each]`, `[unit_price]`, `[plan_name]`, `[savings]`, `[date]`, `[country]`, `[currency]` and others (each setting's `info` lists its own). Render price placeholders through `snippets/price-placeholders.liquid` (and `price-spot` for a spot that must refresh) so they follow the selected variant, tier and currency.
  - **Text formatting:** `[br]` a line break, `[mbr]` and `[dbr]` a break on mobile or desktop only, `[sup]…[/sup]` superscript (footnote marks).
  - **Placeholders a child block fills:** a Heading or Text prints an Inline Icon, Inline Date, Inline Countdown, Inline Location or Rotating Text child where `[icon_1]`, `[icon_2]`…, `[date]`, `[countdown]`, `[location]` or `[rotate]` is typed.
  - **Tags that change structure**, read from a name rather than a setting: in menus, a link named `[button] Shop now` becomes a button, and `[tiles]`, `[rows]` and `[stack]` set a mega menu's layout.

  Reach for one when the choice is occasional and lives naturally inside text the merchant already types. Use a real setting when it changes how the whole component behaves, or when a merchant would never discover a placeholder.
- **Custom Liquid** as a setting is cheap on a section (it lets a later change adjust one placement without editing the file) and almost never worth it on a block.
- **Image loading is automatic:** no lazy-load toggles. **No show/hide toggles** for content a merchant can simply delete.
- **Labels are plain English** in Sugar's schemas (no `t:` keys). Name the visible label in `info` text ("Leave Icon empty to…").

---

## Platform limits that fail silently

- `visible_if` supports `==`, `!=`, `and`, `or`. No `>=`, `<=`, `>`, `<`, no parentheses, at most 250 characters. A bad expression rejects the whole schema.
- Product, collection, page, blog and article pickers can't use `visible_if`.
- A `range` allows at most 101 steps: `(max - min) / step <= 101`.
- A template value must sit inside its range and on its step, and every nested block type must be in its parent's allowlist, or the template silently fails to save or render.
- A section's Custom CSS field refuses more than 500 characters.

---

## Styling

- **Static CSS goes in the component's own asset:** `assets/block-<name>.css` or `assets/section-<name>.css`, loaded with `{{ '<name>.css' | asset_url | stylesheet_tag }}` at the top of the component's markup, above the first element it styles. A page fetches only the sheets of the components it renders, once each. No Liquid inside the asset. Print the link in every component file that needs it, even when many instances share a page: the layout keeps the first copy of each link and drops the repeats on the storefront (each extra link is a stylesheet the browser re-checks on every restyle), so don't try to deduplicate links yourself. Use Shopify's standard `stylesheet_tag` output; a hand-written `<link>` isn't recognized and stays as a duplicate.
- **Setting-driven values are custom properties** on the root element's `style` attribute (`style="--pp-size-d: 18px"`), read by the static sheet. Set every property the sheet reads on every instance (`initial` when unset), so a nested block never inherits its parent's value.
- **No per-instance `<style>` or `<script>`** that could be one shared thing. Each inline `<style>` is its own stylesheet the browser re-checks on every restyle.
- **One root class per component, unique across the theme.** Keep selectors two classes deep at most; to win a tie, repeat the class (`.x.x`) rather than `!important`.
- **Tokens:** colors `rgb(var(--color-foreground))`, `rgb(var(--color-background))`, `rgb(var(--color-accent))` from the active scheme; corners `var(--corner-media|container|badge|button)`; fonts `var(--font-heading-family)`, `var(--font-body-family)`, `var(--font-accent-family)` and their `-weight` and `-style`. `--font-accent-*` always exists (it follows Heading while Accent is off).
- **Bold is one absolute weight.** `strong` and `b` render at the theme's bold through `--sw-bold`. Never write a `font-weight` rule for `strong` or `b` in a component; an element whose own text can be heavier sets `--sw-bold: max(<its weight>, var(--font-body-weight-bold, 700))`.

### Traps that cost earlier agents a broken push

- **Empty elements are hidden.** The theme hides every empty `div` (`div:empty { display: none }`). A decorative element with no content (overlay, bar, spacer) needs `display: block` in a rule two classes deep.
- **Target a block by the end of its id.** `data-_sf` carries a longer id than the block's key in the template JSON: `[data-_sf$="__KEY"]`, never `[data-_sf="KEY"]`.
- **Inline custom properties beat stylesheet rules** setting the same property. Change the setting's value in the template instead of fighting it, and keep `!important` off anything an animation moves.
- **A swipe row that snaps loses its first gutter** on phones: give the scroller `scroll-padding-inline` equal to its side padding. **A card shadow needs room** on the side it falls: any `overflow` other than `visible` cuts it, so pad the scroller (never the cards) or use `overflow: clip` with `overflow-clip-margin`.
- **`:has()` never searches a big element.** Its subject is the component's own class, never `body`, `html`, `main` or a bare tag, and its argument is a short fixed chain of children where possible. The browser re-runs it on every change inside the subject.
- **Moving focus scrolls the page:** use `focus({ preventScroll: true })`.

---

## Colors

- **Color schemes** set background, gradient, text and accent together. Sections and containers pick one; a new component reads the scheme's variables so it follows whatever surface it sits on. Choose a scheme by what its colors do (light or dark, neutral or brand-tinted), not by its number: merchants rearrange them. `DESIGN.md` says what each scheme is for on this store.
- **The palette** names `brand` and `accent` (`settings.color_palette.brand`); swatches a merchant adds are `palette_1`, `palette_2`… with no names. What each is for is recorded in `DESIGN.md`. A palette color can be a picker's default: `"default": "{{ settings.color_palette.brand }}"`.
- **Never read a color picker raw in Liquid.** An unset picker is an empty color object, not `blank`, and a cleared one is transparent. Sugar shadows each picker at the top of the file as `_c_<id>` (an object or `nil`); read that. Never run a color filter on a `var()` string.
- **Outline buttons have no colors of their own:** their text and border follow the scheme where the button sits. Resolve a button's colors on the button, never as a `:root` variable, or a Container's own scheme is ignored.

---

## Scripts

- **Load a component's script from the component**, as an asset with `defer` (`<script src="{{ 'x.js' | asset_url }}" defer></script>`), guarded so it runs once however many instances are on the page.
- **Wrap start-up in `window.SugarReady(fn)`.** It waits for the DOM on the default layout and queues until the scripts arrive on the landing layout, so the same block works on both.
- **Don't assume `global.js` helpers in a content block** (`debounce`, `fetchConfig`, `trapFocus`, `SugarIcon`, `cartStrings`): they exist only on the default layout. `subscribe` / `publish` / `PUB_SUB_EVENTS`, `window.routes` and `window.shopUrl` exist on both.
- **Use the engines that own the behavior; never rebuild them:**
  - Prices, quantity tiers and savings: `SugarPricing` (one store per buy box, `SugarPricing.store({ sectionId, productId, price, compareAt, variantIds })`). Product Price, Product Subtotals, Buy Button, Offers and gifts all settle there.
  - Adding to cart: the product form, which collects extra lines (gifts, add-ons) from elements marked `data-cart-extras`. Don't patch `window.fetch`.
  - Cart drawer: `sugar-cart-drawer`, which redraws from the drawer HTML Shopify returns with each cart change (`sections`), in one request.
  - Sliders: Splide with the shared arrows and dots from `SugarSliderChrome`. A slider must draw its row before Splide mounts (first slide visible, the rest clipped) so nothing jumps.
  - Icons built at runtime: `window.SugarIcon.create(token, className)`.
- **Read everything, then write everything.** An engine serving several instances measures all of them before changing any; a read after another instance's write forces a full layout each time. Never write to `<html>` or `<body>` per frame, and only when the value changed.
- **Nothing hides or moves visible content after the first paint.** Lay out the state the script will leave on the server, so the page doesn't jump when the script runs.
- **Theme editor re-renders:** a section can be rebuilt many times while the merchant edits. Clean up observers, timers and listeners, and make start-up idempotent.

---

## Performance

- **The first screen is the first two content sections of the template** (a template's own header, announcement bars, Page Styles and Page Background don't count). Their images load eagerly with high priority; everything below loads lazily. Follow the pattern the existing media blocks use (`section.index` and `section.location`) instead of inventing a toggle.
- **Images carry `width` and `height`, responsive `widths` and a `sizes` that matches the rendered layout.** Never `sizes="auto"`.
- **Nothing below the fold downloads before the hero:** no eager images, `poster` attributes or `new Image()` preloads further down.
- **Choose the leanest build that still looks and works right.** A setting the merchant will rarely touch costs as much in the template as one they use daily.

---

## Building something new that converts

- **Mobile first.** Most Ecommerce traffic is on phones. Make the phone view compact and legible first, then let desktop use its extra space. Check both, plus a tablet width around 1024px (Sugar shrinks desktop text slightly between 750 and 1199px, on purpose).
- **Bind to the merchant's brand, never copy it.** Read the theme settings and `DESIGN.md`; use their variables so a rebrand carries through.
- **Avoid what makes a design look generated:** monospace accents, an eyebrow over every heading, hover effects on everything, shadows on everything, "fingernail" callout bars, text that clips out of its box, strong glows.
- **Design to sell, not to impress.** A new component exists because nothing in the theme did the job, so make it genuinely useful to the shopper deciding to buy.

---

## Before you finish

- Check the change on a theme that isn't live, in the theme editor and on the storefront, on a phone width and a desktop width, with the settings both empty and filled.
- Run Theme Check where you can and fix real findings.
- Confirm every `range` value in a template is within its min, max and step, and every nested block type is allowed by its parent.
- Record any new section or block, and any change to a shipped Sugar file, under *Store additions* below.
- Tell the merchant which theme you changed and which files.

---

## Component index

Full list with one-line summaries: https://app.sugarthe.me/docs/index.md. Often-needed pages:

- Layout: `custom-columns`, `split`, blocks `custom-column`, `container`, `row`, `double-column`, `slider`, `grid`
- Product page: `product-main` (static `product-media`, `product-info`), blocks `product-price`, `product-buy-button`, `offer-list`, `subscriptions`, `product-variant-picker`, `featured-product-info` (Custom Buy Box)
- Proof and answers: `classic-comparison` and the other comparison blocks, `faq`, `collapsible-row-list`, the review sections, `testimonial-slider`, `marquee`
- Text and media: `heading`, `text`, `media`, `icon-text-list`, `badge`, `link-button`
- Cart: `sugar-cart-drawer` and its blocks

Each lives at `https://app.sugarthe.me/docs/sections/<slug>.md` or `https://app.sugarthe.me/docs/blocks/<slug>.md`.

<!-- STORE ADDITIONS: everything below this line belongs to this store. Theme updates replace the text above it and keep everything below it. Sugar never writes below this line. -->

## Store additions

Agents: when you create a section, block or snippet for this store, add an entry here: the file, what it does, where it's used and when to reach for it. When you change a shipped Sugar file, add a line under *Changes to shipped Sugar files* saying what and why, so a theme update can keep the change.

### This store's custom sections and blocks

_None yet._

### Changes to shipped Sugar files

_None yet._
