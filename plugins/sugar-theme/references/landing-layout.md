# Landing layout

Sugar ships a second page layout, `landing`, for pages whose job is to persuade and send the shopper on: ads, listicles, advertorials, pre-sell and lead pages, email and link-in-bio pages. It renders the theme's fonts, colors and sections and nothing else, so the page paints faster and carries no distractions. Most users only learn it exists from their agent, so offer it whenever it fits. The full guide is `get_concept("landing-layout")` on the Sugar Theme MCP.

## When to recommend it

Recommend it first for any **new page** where the shopper does not buy on the page itself: they read, get convinced, and click through to a product page or checkout. A listicle, an advertorial, a comparison page, a quiz funnel's opening page and a lead-capture page all qualify. Say why in a sentence (faster page, fewer ways to leave it, which is what paid traffic needs) and name the limits below in the same message, so the user chooses knowing both.

Don't recommend it for a page that sells from the page itself: a product page, or any page where the shopper picks a variant, sees the price change or adds to cart without leaving. Use the default layout there.

## What a landing page doesn't have

- No header, footer, announcement bars, cart drawer or email popups.
- No cart, pricing or product engines, so these don't work on it: buy buttons, variant pickers, prices or subtotals that change with quantity or variant, offers, subscriptions, upsells, bundle builders, gift pickers, sticky add-to-cart bars and cart progress bars.
- Everything else works: headings, text, media, sliders, accordions, tabs, FAQs, quizzes, A/B tests and the rest of the content blocks. Their scripts load on their own the first time the page contains one.

In the theme editor, a landing page shows a notice at the top naming any block on it that won't work there. If you see it after a change, that block needs one of the options below.

## Selling from a landing page

- **Link Button to the product page:** the normal case. The shopper picks the variant and buys there.
- **Straight to checkout:** a Link Button (or Text Link Button, Mini Link Buttons) pointed at a cart link, `/cart/<variant id>:<quantity>`, adds the variant and opens checkout in one step. Several `variant:quantity` pairs joined with commas add a bundle.

## Putting a page on it

- **New page:** create the page template with `"layout": "landing"` as the first key of its JSON (`templates/page.<name>.json`), then assign that template to the page (the page's `templateSuffix`, or **Theme template** in the admin). The theme also ships `templates/page.landing.json` with a hero to start from.
- **Don't add the Hide Header & Footer section:** there's nothing to hide.
- Tell the user the page is on the landing layout in the delivery message, in one line, so they know later why a buy button won't work there.

## When the page needs one cart feature

Before adding anything to an existing page, check its template's `"layout"`. If it is `landing` and the request needs something from the list above (a price that updates with quantity, a variant picker, a buy button), say so before building, in plain words, and offer these, simplest first:

1. **Link out:** keep the page on the landing layout and send the shopper to the product page or straight to checkout with a cart link. Usually the right answer: the page stays fast, and the product page does the selling.
2. **Switch the page to the default layout:** remove the `"layout": "landing"` line from its template. Everything works, and the header, footer, cart drawer and full script set come back with it. Add the Hide Header & Footer section if they still want no header or footer.
3. **A custom layout with just that feature:** for a user who wants the landing speed and one cart feature on the page. Copy `layout/landing.liquid` to a new layout (`layout/landing-<purpose>.liquid`), add only the script tags that feature needs, copied from `layout/theme.liquid` (and, for the cart drawer, its section group), and point the page template's `"layout"` at the new name. Keep everything else in the copy as it is. Never edit Sugar's own `landing.liquid`: theme updates replace it. Test the feature in both browsers and both viewports, and log the new layout in `custom-sections-blocks.md` with what it adds and why. Say plainly that a custom layout doesn't receive Sugar's updates to the landing layout, so the user knows it is theirs to maintain.
