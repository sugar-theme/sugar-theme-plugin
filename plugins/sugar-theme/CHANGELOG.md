# Sugar Theme plugin changelog

Newest first. Each entry says what changed for you, and what to do, if anything.

## 0.9.0

- If you share full sessions, the Sugar team now gets the real conversation, sent straight from the file Claude keeps, with passwords, tokens and emails removed. Before, the agent retyped it from memory, which came out as a longer summary.
- Summaries and sessions are sent once per finished task, not after every message.
- A shared conversation is trimmed on your computer first: your messages and the agent's replies word for word, one line per step, and any errors. The raw contents of files and pages the agent looked at never leave your computer. Conversations are deleted after 30 days; summaries are kept.
- The agent now knows the theme's landing layout and recommends it for new listicle, advertorial, pre-sell, lead and ad pages: faster pages with no header, footer, cart drawer or popups. It tells you up front what those pages can't hold (buy buttons, variant pickers, prices that change with quantity, offers, upsells).
- Before adding something to an existing page, the agent checks whether it's a landing page, and if the request needs the cart, it says so and offers options: link out, switch the page back, or a custom layout with just that one feature.
- The catalog the agent reads first now lists the theme's concepts too (landing layout, colors, typography and more).
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once to pick up the new sharing and landing-page rules.

## 0.8.6

- The review link to the theme editor now appears both at the top of the agent's message and again at the very end, so you don't have to scroll up to find it.
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once to pick up the rule.

## 0.8.5

- Build and freestyle read the page you're adding to before suggesting anything, so they no longer propose something it already has.

## 0.8.4

- The agent no longer renames the sections and blocks it places on your pages. They keep their normal names in the editor, which keeps the sidebar uncluttered. New sections and blocks it creates still get a clear name.

## 0.8.3

- Setup checks for Google Chrome and strongly recommends it: Shopify's editor runs better there than in Safari, and Claude in Chrome needs it. It can install Chrome for you and suggests making it your default browser.
- Review links now use Shopify's admin address (admin.shopify.com/store/…), the same one you'd copy from your own admin.
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once to pick up the new review-link rule.

## 0.8.2

- Small wording fixes: the enhance skill checks whether your working theme is the live one, setup names the Shopify app exactly as the approval page shows it, and orders or customers can be added to the store permission when a task needs them, after asking you.

## 0.8.1

- The store permission setup asks for now also covers menus, blog posts, metaobjects and read-only analytics, so the agent can link new pages into your menus and measure a page's sessions and conversion before and after a change. Orders and customers aren't included by default; the agent asks you first if a task needs them.
- **To do:** if you already approved Shopify's command-line app, the agent will ask you to approve it once more the first time it needs one of these.

## 0.8.0

- Password-protected stores open already unlocked in the agent's two browsers. The agent no longer has to type the password, which it refused to do, so both browser checks run again.
- Setup asks once for Shopify's permission to create products, discounts and pages and to upload images to your Files, instead of stopping a task to ask.
- Before any change to products, discounts or pages, the agent tells you exactly what it will change and waits for your yes. Those changes are live immediately, even while you work on a draft theme.
- The custom files log only lists reusable sections, blocks and snippets, not page templates.
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once to pick up these rules and approve the store permission.

## 0.7.0

- The agent now checks for a newer Sugar plugin when you start a task, and offers to update it for you. It always asks first.
- Updating no longer depends on the Update button in the Claude app. After an update, start a new conversation to use it.

## 0.6.2

- Password-protected stores work without turning the password off. Setup notices the password page, asks for the storefront password once and saves it with your project.
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once so it picks up your storefront password.

## 0.6.1

- A pending browser check no longer stops your task. The agent does what you asked and checks the browsers when it first needs them.
- The agent's two browsers start faster and no longer need the internet to start.

## 0.6.0

- Setup runs from `/sugar-theme:setup` after you install the plugin, signs you in to Sugar in the same conversation, and asks whether to keep the plugin updated.
