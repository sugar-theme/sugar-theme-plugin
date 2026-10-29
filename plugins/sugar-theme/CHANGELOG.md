# Sugar Theme plugin changelog

Newest first. Each entry says what changed for you, and what to do, if anything.

## 1.3.11

- **Your custom sections and blocks are now listed in your theme, where Shopify's Sidekick can see them too.** Sugar themes now carry two guide files that Sidekick and this agent both read: `AGENTS.md`, how Sugar is built (with a section at the end listing your store's own sections, blocks and changed files), and `DESIGN.md`, what your colors, color schemes and fonts are for. The agent reads both at the start of every task and keeps the list current, so Claude and Sidekick build the same way and never redo each other's work.
- **Your brand decisions have one home.** When you tell the agent something lasting ("our heading font looks wrong in bold", "the cream swatch is only for cards"), it records it in `DESIGN.md`, which Sidekick follows too.
- **To do:** nothing. The first time the agent works on a theme that has `AGENTS.md`, it offers to move the list it kept in your project folder into the theme. If your theme is older and has no `AGENTS.md` yet, it keeps the project list and suggests a theme update.

## 1.3.10

- **Speed checks look at where your hero sits.** Your theme loads the pictures of only the first two sections of a page up front. When the speed check finds thin strips, a logo row or code-only Custom Liquid sections pushing your hero picture to third place or lower, it now says so and suggests the fix: turn a one-line strip into an Announcement Bar section, merge code-only Custom Liquid sections, or move the hero up. On a test page this made the hero appear about twice as fast.
- **To do:** nothing. Theme 2.1.14 also stops counting sections that draw nothing (A/B tests, redirects, floating bars, code-only Custom Liquid), so updating the theme can fix some pages on its own.

## 1.3.9

- **New sliders keep their first card off the screen edge, and card shadows stop getting cut off.** When the agent builds its own swipe row, it now keeps the same gap before the first card as after the last one on phones, and leaves room for each card's shadow before the progress bar, dots or next block. Grids and containers get the same shadow room.
- **To do:** nothing. A slider or grid the agent already built keeps its look; ask the agent to fix it if you see either problem.

## 1.3.8

- **Two edits to the same file in one task no longer undo each other.** Right after the agent pushes a file, pulling it straight back can briefly return the copy from before that push. The agent now checks that a fresh copy still holds its own last change, and waits and pulls again when it doesn't, so a second push never quietly reverts the first.
- **To do:** nothing.

## 1.3.7

- **The agent's browsers start on Windows.** The Claude desktop app on Windows quietly keeps new folders under AppData\Local in its own private copy, so the Chromium browser setup installed there couldn't start, and the agent couldn't look at your store. Setup now installs both browsers into your home folder, which Windows sees the same way inside and outside the app.
- **To do:** nothing on a Mac. On Windows, run `/sugar-theme:setup` again in your project, then start a new conversation.

## 1.3.6

- **Setup shows you how to switch to your own computer.** Some Claude and Codex accounts open new conversations in a cloud environment, where setup can't install anything or reach your store. When setup finds itself there, it now names the picker to change (in Claude, the environment picker at the bottom left of the chat box; in Codex, **Work in**), so you can choose **This computer** and run it again.
- **To do:** nothing.

## 1.3.5

- **Windows works now.** Setup used to assume a Mac, so on a Windows PC it stopped at the first step and the agent's browsers never started. Setup now gives Claude Git Bash (it uses the one you have, or unpacks a portable copy into your own folder with no administrator password), installs Node.js the same way, and fetches the Windows versions of the video and speed-test tools. At the end you quit and reopen the Claude app once, which switches the browsers on.
- **Setup notices when it isn't on your computer.** A cloud conversation (a Claude Code cloud session, a chat's code sandbox) can't install anything on your computer or reach your store, so setup now says that in its first step, tells you where to run it instead, and doesn't half-install. Questions about the theme still work there.
- **To do:** nothing on a Mac. On Windows, run `/sugar-theme:setup` again in your project.

## 1.3.4

- Bug reports, learnings and shared task summaries now say which model sent them and at what thinking level (for example Sonnet 5.5 at medium), read straight from Claude Code rather than guessed. It helps the Sugar team tell a real bug from a misunderstanding, and nothing else about your setup is sent.

## 1.3.3

- Sections and blocks your agent builds or adds settings to now keep the theme editor tidy: five or six settings per heading at most, grouped by what you're changing (Text, Icons, Spacing), instead of one long list of 20 sliders. When it adds a setting to an existing block, it goes under the heading that fits, or a new heading if that one is full.
- Before handing the work to you, the agent runs a quick check on every section or block it touched. It catches an overloaded heading, a heading that would show empty, and the schema mistakes that make Shopify reject an upload.

## 1.3.2

- Setup now asks Shopify for permission to manage subscription plans (selling plans) along with products and discounts, so your agent can create and attach subscribe-and-save plans without stopping to ask again. Already set up? The next time a task needs it, your agent re-runs the Shopify approval once and carries on.

## 1.3.1

- When something in a Sugar block breaks, your agent now checks what Sugar changed in that exact file since your copy. Every Sugar file names the release it came from on its first line, so the agent can ask "what was fixed in this file after 2.0.0" and bring in a proven fix instead of writing a new one.
- Theme updates use the same line. A file you brought up to date earlier on its own is merged from the release it says it came from, instead of from the release the rest of your theme came from.

## 1.3.0

- Your agent can now look at videos. It can't play one, so it cuts the video into still frames and looks at those: a competitor's autoplay video you want cloned, a video already on your page, or a screen recording you send it of a bug. It sees the picture, not the sound.
- Before a video goes into your store, the agent makes it light: a 20 MB clip typically comes down to a few MB, starts playing before it finishes downloading, and gets a cover image from its first frame. It tells you the size before and after. The speed skill uses the same tool to compress the videos already on your page.
- **To do:** run `/sugar-theme:setup` once in each existing project, so the agent also knows to look at screen recordings and videos you send it. Cloning and speed work pick it up without that. The tool (FFmpeg) installs with no password, and new projects get it during setup.

## 1.2.0

- Your agent can now update your Sugar theme. Ask it to check for Sugar updates: it compares every file of your theme with the latest Sugar, tells you what's new since your copy, replaces the files you never changed, adds new ones, and merges the files you changed that Sugar also changed, keeping what your changes do. It shows you anything it's unsure about before writing it, and nothing reaches your live theme until you publish.
- The app's Store page has a new **Update from your zip** card that does the simple part without an agent. When it finds files that both you and Sugar changed, it gives you a prompt to paste into your agent, and the agent finishes from there.
- When you hit a bug in a Sugar block, your agent first checks whether Sugar already shipped a fix for it.

## 1.1.0

- The agent now finds icons in Sugar's icon library instead of guessing their names. It searches the whole library (about 30,000 icons and emoji) by what the icon shows, the set your store already uses and the kind of message (shipping, trust, discounts and more), checks each name before using it, and can send you a link to the library already filtered so you can pick by eye. Before, a wrong guess showed no icon at all.
- Links to the icon library point to its real address, app.sugarthe.me/icons.

## 1.0.0

- Several conversations can now work on your store at the same time without tripping over each other. Each keeps its own temporary copy of the files it is editing; before, one could clear another's copy and have to fetch the files again.
- The agent can now remove a variations template, and the losing variation's files, once you've picked a winner. It deletes exactly the files it names and checks they're gone; it can't touch your layouts, settings, main templates or your live theme. Before, those templates stayed behind in your editor.
- Speed tests now work on a password-protected store: the agent measures your draft theme itself, not the password page, and without Shopify's preview bar inflating the numbers.
- Uploads are steadier: new blocks go up before the page that uses them, and every upload is checked against what actually landed on the store.
- The agent tests more reliably in its browsers: it hides the preview bar, scrolls like a shopper, and waits out the store's short delay after an upload instead of chasing problems that aren't there.
- When cloning a page whose icons only roughly match Sugar's icon library, the agent asks whether to use the reference's own icons or the closest Sugar ones.
- The agent can now read the docs of child blocks too, such as the cart's Progress Item, Offer and table cells, instead of reading the theme's code.
- A shared conversation is shorter: an element you tag in the browser is sent as its text, not the other site's full page code.
- **To do:** run `/sugar-theme:setup` once in each project to pick up the rule for working alongside other conversations.

## 0.9.1

- A shared conversation is trimmed on your computer first: your messages and the agent's replies word for word, one line per step, and any errors. The raw contents of files and pages the agent looked at never leave your computer. Conversations are deleted after 30 days; summaries are kept.
- The agent now knows the theme's landing layout and recommends it for new listicle, advertorial, pre-sell, lead and ad pages: faster pages with no header, footer, cart drawer or popups. It tells you up front what those pages can't hold (buy buttons, variant pickers, prices that change with quantity, offers, upsells).
- Before adding something to an existing page, the agent checks whether it's a landing page, and if the request needs the cart, it says so and offers options: link out, switch the page back, or a custom layout with just that one feature.
- The catalog the agent reads first now lists the theme's concepts too (landing layout, colors, typography and more).
- **To do:** run `/sugar-theme:setup` once in each project to pick up the landing-page rule.

## 0.9.0

- If you share full sessions, the Sugar team now gets the real conversation, sent straight from the file Claude keeps, with passwords, tokens and emails removed. Before, the agent retyped it from memory, which came out as a longer summary.
- Summaries and sessions are sent once per finished task, not after every message.
- **To do:** in a project set up before this version, run `/sugar-theme:setup` once to pick up the new sharing rule.

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
