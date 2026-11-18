# Sugar Theme catalog index

Sugar 2.3.17 · catalog `9e2725ec3948` · generated, do not edit.

One line per section and block, grouped the way the theme editor's add menu groups them. This answers whether something exists, roughly what it does, and where it sits in a page. For how a component works, its settings, its full list of allowed children and its known issues, fetch its docs from the Sugar Theme MCP by slug (`get_component`). The MCP's `list_catalog` is the live version of this list.

Each line ends with the component's place in a page's structure:

- **Role:** `holding` exists to hold other blocks and shows little of its own. `content` shows something itself; any child blocks only decorate it. `holding + content` does both.
- **Inside:** the only parents it can be added to, listed when there are a few. Without it, the block fits in most layout blocks.
- **Holds:** what goes inside it, in brief. `content blocks` means the general set of headings, text, media, buttons and so on; `accents` means decorations such as a badge, an icon or a text highlight.

Contents: 210 blocks, 69 sections.

## Sections

### Advanced

- **Apps** `apps` — Add app blocks from installed apps in a section of their own, with the theme's spacing around them. · holding · holds app blocks
- **Custom Liquid** `custom-liquid` — Add a section of custom Liquid, HTML, CSS or JavaScript, with its own padding, for anything the theme doesn't cover. · content

### Advertorial

- **Advertorial** `advertorial` — Lay out a long-form sales article beside a sidebar that stays in view, such as a product teaser with a link to the offer. · holding · holds Content and Sidebar

### Animations

- **Marquee** `marquee` — Run scrolling tracks of claims, logos or reviews across a full-width band, with an optional heading above them. · holding · holds Marquee Tracks and a heading

### Announcement

- **Announcement Bar** `announcement-bar` — Run a strip of promises above the header, optionally sticky, sliding or shown on selected pages. · holding + content · holds Announcement Column

### Blog

- **Blog List** `blog-list` — Show blog posts as a grid, collage or slider of cards, with optional tag badges, reading time, and per-post overrides. · holding + content · holds Article
- **Blog Navigation** `blog-navigation` — Show a blog's tags, or links you pick, as a row of pills readers tap to filter posts, optionally pinned as they scroll. · holding + content · holds Link
- **Blog Post** `blog-post` — Lay out a blog post with an optional sidebar for a table of contents, authors, and a newsletter box. · holding · holds post parts, such as title, content and share buttons

### Cart

- **Cart Drawer** `sugar-cart-drawer` — Slide the cart in from the side of every page, with a header, body, footer and its own empty state. · holding + content · holds header, announcements, body and footer

### Collection

- **Collection Header** `collection-header` — Open a collection page with breadcrumbs or a back link, the collection's title and a description that folds on phones. · content
- **Collection Link List** `collection-link-list` — List a collection's products as text links with prices in a row that opens, for shoppers who scan and for search engines. · content
- **Collection Navigation** `collection-navigation` — Link between collections with a row of pills, underlined labels, or image tiles that marks the one being viewed. · holding + content · holds Collection
- **Collections List** `collections-list` — Show collections as a grid or slider of cards, with an optional product count and per-collection overrides. · holding + content · holds Collection Item and Grid Promo
- **Featured Collection** `featured-collection` — Show products as a grid or slider of cards, with prices, optional ratings, swatches, quick add, and filters on collection pages. · holding + content · holds Product Item and Grid Promo

### Content

- **Expert Videos** `expert-videos` — Present expert video answers in swipeable cards with expandable answers and biographies. · holding + content · holds Answer
- **Ingredient Cards** `ingredient-cards` — Show what's in a product as a paged grid of ingredient cards, each with a photo, a dose, a name and a line. · holding + content · holds Ingredient
- **Progress Tabs** `progress-tabs` — Walk shoppers through what to expect week by week, with tabs, a benefits list and a chart that grows each step. · holding + content · holds Stage

### Decoration

- **Page Background End** `page-background-end` — Stop a Page Background at this point, so the sections below return to their normal width and edges. · content
- **Section Divider** `section-divider` — Shape the seam between two sections with a wave, angle, curve, arch or dashed swirl, optionally animated. · content

### Forms

- **Email Signup** `email-signup` — Give a newsletter form its own band across the page, with an optional gradient and its own width. · holding · holds content blocks

### Hero

- **Full Width Hero** `full-width-hero` — Fill the top of a page with one edge-to-edge image or video and place content anywhere over it. · holding + content · holds Section Content
- **Hero Carousel** `hero-carousel` — Fade between hero slides, each with its own background, overlay and content, such as one offer per slide. · holding + content · holds Hero Slide
- **Split Hero** `split-hero` — Set an image or video beside a column of content at a ratio you choose, with an optional color scheme on the content half. · holding + content · holds Section Content

### Layouts

- **Custom Columns** `custom-columns` — Lay out columns of any width on a 12-column grid, such as halves, thirds or a main area beside a sidebar. · holding · holds Column and Custom Liquid
- **Split** `split` — Divide a section into two sides at an exact ratio, each with its own optional colors that run to the edge of the screen. · holding · holds Column and Split Row

### Marketing

- **Email Popup** `email-popup` — Collect email addresses in a card over the page, with an optional game or question first and a coupon after. · holding + content · holds its Pre-Opt-In, Opt-In and Success pages
- **Full Screen Email Popup** `full-screen-email-popup` — Collect email addresses in a takeover that fills the screen, with an optional background image and content placed anywhere on it. · holding + content · holds its Pre-Opt-In, Opt-In and Success pages

### Media

- **Alternating Media + Text** `alternating-media-with-text` — Stack rows of media and text that flip sides down the page, with optional dividers between them. · holding · holds content blocks
- **Media Banner** `media-banner` — Show a full-width image or video banner, with its own media for mobile and an optional link. · content · holds accents
- **Media with Text** `media-with-text` — Pair one image or video with a column of blocks, with an optional card that overlaps the media. · holding + content · holds content blocks

### Product

- **Featured Product** `featured-product` — Show any product's gallery and buy box on a page other than its own, such as a hero offer on the homepage. · holding · holds Buy Box and Product Media
- **Hotspots** `hotspots` — Point out a product's parts with numbered markers on a picture that open matching rows in a list beside it. · holding + content · holds Spot
- **Popup Cards** `popup-cards` — Show a row of picture cards that each open a detail popup, such as flavors with nutrition facts. · holding + content · holds Card
- **Product Spotlight** `product-spotlight` — Announce a new product with a launch card holding its name, flavor swatches, a looping video and a button. · holding + content · holds Swatch
- **Study Table** `study-table` — Show clinical results as a striped table, one row per benefit, with the study behind each one. · holding + content · holds 3 kinds of block

### Quiz

- **Quiz Loading** `quiz-loading` — Hold a quiz on an animated loading step, then advance on its own or wait on a checkpoint. · holding · holds Quiz Content
- **Quiz Main** `quiz-main` — Run a multi-step quiz, with the logo bar, progress, navigation and answer styling every step shares. · holding · holds quiz chrome, such as logo, progress bar and navigation
- **Quiz Page** `quiz-page` — Add one question or interstitial step to a quiz, with its own width, background and advance behavior. · holding + content · holds Quiz Content

### Social Proof

- **As Seen On** `as-seen-on` — Show a strip of press or partner logos, still, scrolling or paged, with an optional header and quotes. · holding + content · holds Logo
- **Before & After Reviews** `before-after-reviews` — Show customer reviews with before and after photos, one at a time, sorted into pills by concern. · holding + content · holds Review
- **Before & After Slider** `before-after-slider` — Show customers' before and after photos over their reviews, in a row that swipes or scrolls itself. · holding + content · holds Customer
- **Expert Cards** `expert-cards` — Introduce the experts behind a product as portrait cards with a frosted bio, in a swipeable row. · holding + content · holds Expert
- **Expert Reviews** `expert-reviews` — Show reviews written by clinicians or other experts, with credentials, a folding review, topics and highlights. · holding + content · holds Expert
- **Judge.me Style Reviews** `judgeme-reviews` — Show reviews in a Judge.me style widget, with a rating summary, star filters, helpful votes and merchant replies. · holding + content · holds Review
- **Junip Style Reviews** `junip-reviews` — Show reviews in a Junip style two-column list, with reviewer details, reviewed products and an optional rating summary. · holding + content · holds Review and Photo
- **Okendo Style Reviews** `okendo-reviews` — Show reviews in an Okendo style widget, with a rating breakdown, photo strip, filters and optional scales and questions. · holding + content · holds 4 kinds of block
- **Yotpo Style Reviews** `yotpo-reviews` — Show reviews in a Yotpo style list, with optional rating bars, a customer summary, topic chips, search and paging. · holding + content · holds Review and Topic

### Sticky

- **Custom Sticky** `custom-sticky` — Pin any blocks in a bar at the window's top or bottom, such as a buy button or a countdown. · holding · holds Desktop Bar and Mobile Bar
- **Sticky Navigation** `sticky-navigation` — Pin a jump bar of menu items that scroll to each section and mark the one in view. · holding · holds menu items, logo, button and country picker
- **Sticky Product** `sticky-product` — Keep an add-to-cart control on screen as shoppers scroll a product page, as a full bar or a floating button. · holding · holds desktop bar, mobile bar and buy button

### Storytelling

- **Expanding Panels** `expanding-panels` — Walk shoppers through the parts of a system as side-by-side strips that open to a photo. · holding + content · holds Panel
- **Stacked Cards** `stacked-cards` — Tell a story in big rounded photo cards, with an optional stack that pins each card as the next slides over it. · holding · holds Card
- **Story Cards** `story-cards` — Show a brand's history as dated cards, in a row that enlarges the clicked card or a slider over a backdrop photo. · holding + content · holds Card

### Support

- **Contact Form** `contact-form` — Build a contact form field by field, such as name, email, topic and message, each field its own block. · holding + content · holds form fields
- **FAQ** `faq` — Answer common questions in an accordion section, with optional categories a shopper can tab between. · holding + content · holds FAQ Category
- **Order Tracking** `order-tracking` — Let shoppers track a package by number, or sign in to see every order and its tracking. · content · holds accents

### Templates

- **404 page** `main-404` — Show the page a visitor lands on for a missing address, with a link back to your products. · content
- **Cart Page** `main-cart` — Give the cart its own page, with the shopper's items beside an order summary built from the cart drawer's blocks. · holding + content · holds cart blocks
- **Password footer** `main-password-footer` — Close the password page with social icons, a custom line, and optional Shopify and owner-login links. · holding + content · holds Social Icons
- **Password header** `main-password-header` — Top the password page with the store logo and an enter-password button that opens a dialog. · content

### Utility

- **Floating Cart** `floating-cart` — Replace the store header on one page with a cart button that floats under a sticky announcement bar. · content
- **Footer** `footer` — Build the site footer from columns of menus, logos and sign-up forms, with an optional background image. · holding + content · holds content blocks
- **Header** `header` — Run the logo, menu and icons across the top of every page, with a slide-in drawer for phones. · holding · holds logo, menus, icons and drawer
- **Hide Header & Footer** `hide-header-footer` — Strip the site chrome off one page, for a landing page or a checkout-style flow. · content
- **Page A/B Test** `page-ab-test` — Split visitors between two templates of the same page, at the same URL, and measure which layout sells better. · content
- **Page Redirect** `page-redirect` — Send visitors on to another page after an optional delay, such as from a retired landing page. · content
- **Page Styles** `page-styles` — Override the colors, buttons, fonts and popup backdrop of one page without changing the rest of the store. · holding · holds color scheme, button, font and popup backdrop overrides
- **Section A/B Test** `section-ab-test` — Split visitors between two sets of sections on a page, or test a section against not having it, and measure which sells better. · content
- **Setup Guide** `setup-guide` — Walk a new store through its first theme settings, from the logo to fonts, corners, and buttons. · content

## Blocks

### Advertorial

- **Content** `advertorial-content` — Hold the article in an advertorial's main column, on an optional card, from headings and images to reviews and buy buttons. · holding · inside Advertorial · holds content blocks
- **Reviews Summary** `advertorial-reviews` — Show a typed-in average rating and star breakdown, with optional ratings by feature, in an advertorial or a rating popup. · content · inside Content, Popup, Sidebar
- **Sidebar** `advertorial-sidebar` — Hold an advertorial's sidebar, which stays in view as the article scrolls, such as a product teaser with a link to the offer. · holding · inside Advertorial · holds content blocks

### Animations

- **Animated Counter** `animated-counter` — Count one figure up as it scrolls into view, in whatever format it's typed. · content
- **Animated Counters** `animated-counter-list` — Lay out several counting figures in a grid, all sharing one look. · holding · holds Counter
- **Marquee** `marquee` — Scroll rows of trust claims, logos, or reviews across the page, or columns of photos up and down, on a continuous loop. · holding · holds Marquee Track
- **Percentage Circle** `percentage-circle` — Show one statistic as a number counting up inside a ring that fills to match it. · content
- **Percentage Circles** `percentage-circle-list` — Lay out several percentage rings in a grid, all sharing one look. · holding · holds Circle
- **Progress Bar** `progress-bar` — Show stock, progress or a rating as a bar that fills as one length, as segments or as dots. · content
- **Rotating Text** `rotating-text` — Cycle a short line through several messages on a timer, faded, slid or typed, with optional icons or star ratings. · holding · holds Text Item and Review Item

### Badges

- **Activated Badge** `activated-badge` — Label a timeline milestone with a pill that shifts from its inactive to its active colors as the milestone lights up. · content · inside Milestone
- **Badge** `badge-list-item` — Add one badge to a badge list, with its own text and optional icon, styled by the list. · content · inside Badge List
- **Badge** `badge` — Highlight a short claim in a compact pill with an optional icon, such as Free Shipping or Bestseller. · content
- **Badge List** `badge-list` — Show a row of badges that share one style, such as trust claims under a buy button. · holding · holds Badge
- **Chip Badge** `chip-badge` — Flag a status in a small pill with a leading dot, in a solid or glass style, such as Back in stock. · content
- **Stamp** `stamp-list-item` — Add one stamp to a stamp list, with its own ring text and an icon or stacked lines. · content · inside Stamp List
- **Stamp** `stamp` — Print a seal with curved ring text and an icon or stacked lines at its center, such as a guarantee or a discount. · content
- **Stamp List** `stamp-list` — Lay out a row of stamps that share one shape, size, and text style, such as a set of trust marks. · holding · holds Stamp

### Blog

- **Article** `blog-list-item` — Add one article card to a blog list, with optional title, excerpt, image, and button overrides. · content · inside Blog List · holds accents

### Buttons

- **Buy Button** `product-buy-button` — Add the product to the cart with custom text, live prices, and optional icons, badges and hover animations. · content · holds accents
- **Link Button** `link-button` — Link to a page or scroll to a section from a button, with an optional second line, icons and hover effects. · content · holds accents
- **Mini Link Buttons** `mini-link-buttons` — Jump between sections of a long page with a row of small pill buttons. · holding + content · holds Mini Link Button
- **Text Buy Button** `text-buy-button` — Add the product to the cart from a plain text link, with live prices and text hover effects. · content · holds accents
- **Text Link Button** `text-link-button` — Link to a page or scroll to a section from a line of text, with text hover effects. · content · holds accents

### Card

- **Card Badge** `card-badge` — Pin a label to one card, over its image or under its text, with optional icon and colors. · content · inside Article, Collection Item, Product Item
- **Card Benefit** `card-benefit` — Add a short icon-and-text reason to buy under one card's content. · content · inside Article, Collection Item, Product Item
- **Card Sticker** `card-sticker` — Stamp a circle or starburst on one card's image, with optional rotation, shadow, and motion. · content · inside Article, Collection Item, Product Item

### Collection

- **Collection Item** `collections-list-item` — Add one collection card to a collections list, with optional title, description, image, and button overrides. · content · inside Collections List · holds accents
- **Grid Promo** `grid-promo` — Place a promo tile inside a product grid, after any card, one card wide, two cards wide or across the row. · holding · inside Collections List, Featured Collection · holds 5 kinds of block
- **Product Item** `featured-collection-item` — Add one product card to a featured collection, with optional title, image, price, and rating overrides. · content · holds accents

### Columns

- **Column** `custom-column` — Stack blocks in a column and set how wide it runs on desktop and on mobile. · holding · inside Custom Columns · holds content blocks
- **Column** `split-column` — Fill one side of a Split section with blocks, aligned against the column beside it. · holding · inside Split · holds content blocks
- **Split Row** `split-row` — Span both columns of a Split section with a full-width row, for a heading above them or a strip below. · holding · inside Split · holds content blocks

### Comparisons

- **Card Comparison** `table-comparison` — Compare in a flat table on desktop that restacks into one card per feature on phones. · holding + content · holds Comparison Row
- **Column Cards Comparison** `container-comparison` — Compare your product against 1 or 2 competitors with each column drawn as its own card. · holding + content · holds Comparison Row
- **Comparison Table** `classic-comparison` — Compare your product against up to 4 competitors in a checkmark table, with your column raised and highlighted. · holding + content · holds Comparison Row
- **Custom Table** `custom-table` — Build any table from column, row and cell blocks, such as a product lineup or a dosage chart. · holding + content · holds Table Column and Table Row
- **Heading + Text Comparison** `long-form-comparison` — Compare features that need explaining, with a heading and body text per row and a verdict per column. · holding + content · holds Comparison Row
- **Pathway Comparison** `pathway-comparison` — Contrast two step-by-step journeys, each a column of pills ending in a summary card. · content
- **Side-by-Side Comparison** `side-comparison` — Set your claims beside a competitor's in two columns of icon, heading and text rows. · holding + content · holds Side-by-Side Row
- **Stacked VS Comparison** `vertical-comparison` — Stack your card above a competitor's with a VS badge at the seam, for narrow columns. · content

### Form

- **Newsletter Signup** `newsletter-signup` — Collect email subscribers with a field and a button, with an optional heading and a discount code shown after signing up. · content · holds accents

### Forms

- **Coupon** `coupon` — Show a discount code shoppers copy with one tap, applying it to their cart at the same time. · content
- **Discount Code Input** `cart-discount-input` — Let shoppers type a discount code in the cart and see it applied before checkout. · content · inside Cart Page, Footer
- **Dismiss Button** `dismiss-button` — Give the email popup's success page a button that closes the popup or sends the shopper to another page. · content · inside Success Page
- **Email Input** `email-input` — Collect a shopper's email address in an email popup, a popup, an accordion or a container, with an optional inline submit arrow and customer tags for segmenting. · content
- **Multiple Choice** `multiple-choice` — Ask shoppers a question in the email popup and tag them by their answer, as radios, pills, icons or a dropdown. · content · inside Opt-In Page, Pre-Opt-In Page
- **Opt-In Button** `opt-in-button` — Submit an email sign-up, in an email popup or beside an email input anywhere else, with a button in a theme button style and optional icons. · content
- **Popup Button** `popup-button` — Move a shopper through an email popup or close any popup, with a button or a plain text link. · content

### Gifts

- **Featured Gift** `featured-gift` — Offer one free gift with the order, with its value struck through and an optional badge. · content
- **Gift Grid** `gift-grid` — Lay out several free gifts as cards in a grid, each with its value struck through. · holding + content · holds Gift Item
- **Gift List** `gift-list` — Stack several free gifts as full-width rows, each with its value struck through. · holding + content · holds Gift Item
- **Gift Picker** `product-gift-picker` — Let shoppers choose their free gift on the product page, added with the buy button. · holding + content · holds Gift Choice
- **Gift Unlocks** `gift-unlocks` — Show a row of free gifts that unlock as the shopper raises quantity or picks a variant. · holding + content · holds Gift Unlock

### Headings

- **Heading** `heading` — Add a heading with its own SEO tag and sizes per device, plus optional highlights, icons and live values. · holding + content · holds Highlight Emoji and Rotating Text
- **Heading + Text** `heading-text` — Stack a heading and a paragraph as one block, for pairs that sit side by side in a row. · holding + content · holds Highlight Emoji and Rotating Text

### Hero

- **Media Stamp** `media-stamp` — Stamp up to three lines of text in a circle, scalloped circle, seal, starburst or shield on an image, such as 25% OFF. · content · holds accents

### Icons

- **Icon** `icon` — Show a single icon or emoji at its own size, such as a check mark in a table cell or a row. · content
- **Icon + Heading + Text** `icon-text` — Pair an icon with a heading and optional supporting text, placing the icon above or beside them. · content · holds accents
- **Icon + Heading List** `icon-heading-list` — List points with a heading and supporting line each, beside a shared icon or a number that counts up. · holding · holds List Item
- **Icon + Text List** `icon-text-list` — List short points with an icon beside each one, stacked or in columns. · holding · holds List Item
- **List Item** `icon-heading-list-item` — Add one point to an icon + heading list, with a heading, a supporting line and its own icon if needed. · content · inside Icon + Heading List
- **Payment Badges** `payment-badges` — Show the card and wallet logos you accept, such as Visa, Apple Pay, or Klarna. · content
- **Social Icons** `social-icons` — Show a row of social profile icons, from the theme's settings or a hand-picked list. · holding · holds Social Link

### Interactive

- **FAQ Pill** `faq-pill` — Add one question to FAQ Pills, with the answer it opens and an icon on its pill. · content · inside FAQ Pills
- **FAQ Pills** `faq-pills` — Turn common questions into tappable pills that open an answer below or in a tooltip, such as shipping. · holding · holds FAQ Pill
- **Milestone** `milestone` — Add one step to a timeline, with any content blocks and an optional image across a centered line. · holding + content · inside Timeline · holds content blocks
- **Popup** `popup` — Open a window over the page from a link, button, row or image, such as a size guide or fine print. · holding + content · holds content blocks
- **Reveal Card** `reveal-card` — Hold one card's face and the blocks revealed when a shopper opens it. · holding + content · inside Reveal Cards · holds content blocks
- **Reveal Cards** `reveal-cards` — Lay out cards in a grid or a slider that open to show more, such as values or benefits. · holding · holds Reveal Card
- **Reveal Content** `milestone-reveal` — Show content in a milestone only once the timeline reaches it, such as a detail or a button. · holding · inside Milestone · holds content blocks
- **Scratch Off** `scratch-off` — Hide a reward under foil for shoppers to scratch away, such as a mystery discount in an email popup. · holding + content · holds content blocks
- **Timeline** `timeline` — Walk shoppers through steps or a results schedule as milestones on a line, vertically or as a slider. · holding · holds Milestone

### Layout

- **Vertical Divider** `vertical-divider` — Draw a vertical line between blocks in a row, stretching to the row's height or set to a fixed one. · content · inside Footer Column, Quiz Content, Row

### Layouts

- **A/B Test** `ab-test` — Split visitors between two versions of your content and measure which one sells better. · holding · holds Variant
- **Container** `container` — Group blocks into a container with its own padding, colors, and border. · holding · holds content blocks
- **Custom Liquid** `custom-liquid` — Add an app snippet or custom Liquid code wherever a block can go, for anything the theme doesn't cover. · content
- **Cutout Card** `cutout-card` — Anchor a cutout image to the edge of a card and set a heading, endorsement or offer beside it. · holding + content · holds content blocks
- **Divider** `divider` — Separate stacked content with a horizontal line, optionally broken by an icon or a short label. · content
- **Double Column** `double-column` — Divide a card into two columns at a set ratio, each with optional colors, stacked or side by side on mobile. · holding · holds Column
- **Numbered Stages** `numbered-stages` — List steps beside numbered circles, each with a small label, a heading and text, such as how a product works. · holding · holds Stage Item
- **Quiz Continue** `quiz-continue` — Give one quiz step its own advance button, replacing the shared Next button there. · content · inside Column, Container, Quiz Content
- **Quiz Summary** `quiz-summary` — Show a quiz result as a card, with an optional level bar, alert and grid of stat figures. · holding + content · inside Container, Quiz Content · holds Summary Stat
- **Row** `row` — Lay blocks out side by side, with control over how they align, distribute, and share the width. · holding · holds content blocks
- **Section Content** `section-content` — Hold the heading, text and buttons of a hero or Media with Text section, placed where the section puts its content. · holding · inside Full Width Hero, Media with Text, Split Hero · holds content blocks
- **Stage Item** `numbered-stage-item` — Add one numbered step to Numbered Stages, with a small label, a heading and optional body text. · content · inside Numbered Stages
- **Variant** `ab-variant` — Hold the content for one side of an A/B test, either the current version or the challenger. · holding · inside A/B Test · holds content blocks

### Marquee

- **Marquee Badge** `marquee-badge` — Scroll a pill of text on its own colored surface, as one item in a marquee. · content · inside Marquee Track
- **Marquee Image** `marquee-image` — Scroll a logo or badge image as one item in a marquee, with optional grayscale or recoloring. · content · inside Marquee Track
- **Marquee Item** `marquee-item` — Pair a short claim with an icon, as one item in a scrolling marquee. · content · inside Marquee Track
- **Marquee Review** `marquee-review` — Scroll a star rating, a short quote, and an author as one item in a marquee. · content · inside Marquee Track
- **Marquee Track** `marquee-track` — Scroll one row or column of items on a loop, with its own direction, speed, and spacing. · holding · inside Marquee · holds marquee items

### Media

- **Before & After** `before-after` — Compare a before and after image with a divider shoppers drag, or reveal it on hover, scroll or tap. · content
- **Content Card** `content-card` — Give a section's content column its own surface, and decide how far it overlaps the media. · content · inside Alternating Media + Text, Media with Text
- **Custom Video Controls** `video-controls` — Give a video a play button plus optional replay, sound, fullscreen and timeline controls or a full control bar, each placed and styled separately. · content
- **Gallery** `gallery` — Build a carousel from hand-picked images and videos, with no product behind it. · holding · holds Gallery Item and Gallery Container
- **Logo** `logo` — Show the store's logo anywhere on a page, such as a footer, with an optional link. · content
- **Media** `media` — Show an image or video in a frame of your choice, with optional overlays such as a badge or caption. · content · holds accents
- **Media & Text Row** `media-text-row` — Add one row of media and blocks to an alternating media section. · holding + content · inside Alternating Media + Text · holds content blocks
- **Media Text Overlay** `media-text-overlay` — Caption an image or video with a heading and supporting line over a fade that keeps them readable. · content · inside Media
- **Simple Video Controls** `video-controls-simple` — Give a video a play button plus optional replay, sound, fullscreen and timeline controls in one shared style. · content
- **Social Media Videos** `social-media-videos` — Show short vertical videos, such as customer clips, in a swipeable row that opens each one in a popup. · holding · holds Video Item
- **Variable Media** `variable-media` — Swap a media panel as each trigger beside it becomes active, on a timer, on click or on scroll. · holding · holds Media Item
- **Video Item** `social-media-video-item` — Add one video to a Social Media Videos row, with an optional thumbnail and an optional longer video for the popup. · content · inside Social Media Videos · holds accents

### Navigation

- **Advertorial Breadcrumbs** `advertorial-breadcrumbs` — Show a hand-written breadcrumb trail, such as Home › Health › Article Title, to make a sales page read like an article. · content
- **Breadcrumbs** `breadcrumbs` — Show the product's place in the store, such as Home › Collection › Product, and describe it to search engines. · content

### Popup

- **Matching Cards** `matching-cards` — Let shoppers flip cards to reveal offers, such as a pick-a-gift game in an email popup or on a pre-gift page. · holding + content · holds 6 kinds of block
- **Opt-In Page** `email-popup-opt-in` — Hold an email popup's sign-up form and set when the popup opens, such as after a delay or on exit intent. · holding · inside Email Popup, Full Screen Email Popup · holds content blocks
- **Pre-Opt-In Page** `email-popup-pre-opt-in` — Add an optional first step to an email popup, such as a question or a scratch-off, before the sign-up form. · holding · inside Email Popup, Full Screen Email Popup · holds content blocks
- **Spin Wheel** `spin-wheel` — Let visitors spin a prize wheel in the email popup that always lands on the offer you choose. · holding + content · inside Container, Popup, Pre-Opt-In Page · holds 6 kinds of block
- **Success Page** `email-popup-success` — Thank shoppers once they sign up to an email popup, with an optional coupon, confetti, auto-close or redirect. · holding · inside Email Popup, Full Screen Email Popup · holds content blocks

### Product

- **Product Media** `product-media` — Show a product's own images and videos as a carousel, a stacked column, or a grid. · holding + content · inside Featured Product, Product Main · holds content blocks

### Product Details

- **Benefit Card** `benefit-card` — Place one benefit inside a Media Benefits Grid, with an icon, a label, and an optional description. · content · inside Media Benefits Grid
- **Custom Buy Box** `featured-product-info` — Build a buy box for any product anywhere on a page, from blocks such as title, price and buy button. · holding · holds content blocks
- **Custom Product Media** `custom-product-media` — Show any product's images and videos as a gallery, anywhere on the page. · holding + content · holds content blocks
- **Media Badge** `media-badge` — Pin a short label with an optional icon on an image or video, such as 3 Free Gifts. · content · holds accents
- **Media Banner** `media-banner` — Run a text strip across the top or bottom of an image or video, such as a free shipping offer. · content · inside Custom Product Media, Media, Product Media · holds accents
- **Media Benefits Grid** `media-benefits-grid` — Split a product gallery slide into the image and a column of benefit cards beside it. · holding · inside Custom Product Media, Product Media · holds Benefit Card
- **Media Card** `media-card` — Place a small card with a heading, text and an optional image over media, such as a gift offer or a product chip. · content · inside Custom Product Media, Media, Product Media · holds accents
- **Media Effect** `media-effect` — Float an image gently up and down, with optional sway, pulse or tilt, to bring a product cutout to life. · content
- **Media Gallery Content** `media-gallery-content` — Show the blocks under the product gallery at this spot in the buy box on mobile, without duplicating them. · content · inside Buy Box, Custom Buy Box
- **Media Image** `media-image` — Layer a second image over an image or video, such as an award seal or a hand-drawn arrow. · content · inside Custom Product Media, Media, Product Media · holds accents
- **Media Play Button** `media-play-button` — Show a play button over an image or video, optionally opening a video or other content in a popup. · content · inside Custom Product Media, Media, Product Media · holds accents
- **Product Description** `product-description` — Show the product's description, folding long copy behind a Read more button at a set height. · content
- **Product Price** `product-price` — Show a product's price beside the compare-at price it is discounted from, with an optional sale badge. · content · holds accents
- **Product Subtotals** `product-subtotals` — Show what the shopper is saving and what the cart will come to, updating live as they choose. · content
- **Product Title** `product-title` — Show the product's name as a heading, with its own size, font and an optional gradient. · content
- **Shop Pay Installments** `shop-pay-installments` — Show Shopify's Shop Pay installments message for a product or the cart total. · content
- **Size Chart** `size-chart` — Lay out measurements by size in a table, with an optional toggle between inches and centimeters. · content
- **Supplement Facts** `supplement-facts` — Show a supplement or nutrition facts label typed as plain rows, with indents, thick bars, and daily value notes. · content

### Product Options

- **Bundle Builder** `bundle-builder` — Let shoppers tap the variants they want, with a tier bar that reprices each unit as the count grows. · holding + content · holds 4 kinds of block
- **Offer Cards** `offer-cards` — Sell a product in quantity tiers set side by side as cards, each with its own discount and optional badges, perks and gifts. · holding + content · holds Offer and Variant Picker
- **Offer List** `offer-list` — Sell a product in quantity tiers stacked as rows, each with its own discount and optional badges, perks and gifts. · holding · holds Offer and Variant Picker
- **Offer Pills** `offer-pills` — Let shoppers pick an offer tier with a row of pills, such as a dog size that recommends a pack. · content
- **Personalization** `personalization` — Ask shoppers for engraving text, a gift message, a photo or an option before they buy, with an optional paid add-on. · content
- **Product Upsells** `product-upsells` — Offer add-on products beside the buy button that a shopper selects and adds with the main product in one click. · holding + content · holds Upsell Item
- **Quantity Selector** `product-quantity-selector` — Let shoppers pick a quantity with plus and minus buttons or a dropdown before adding to cart. · content
- **Silent Subscription** `silent-subscription` — Put a subscription plan on the product form with nothing for the shopper to pick. · content
- **Step 2** `step-two` — Turn the buy box into a two-step page, such as picking a bag count and then a flavor for each bag. · holding + content · inside Buy Box · holds content blocks
- **Subscription Toggle** `subscription-toggle` — Turn a product's subscription on with one card and a checkbox, the plan's price always in view. · holding + content · holds content blocks
- **Subscriptions** `subscriptions` — Sell a product on a subscription plan or as a one-time purchase, with two cards that reprice the page as the shopper picks. · holding + content · holds content blocks
- **Variant Picker** `product-variant-picker` — Let shoppers pick a product's variant, one option at a time, as pills, swatches, images, cards or a dropdown. · holding + content · holds Option blocks

### Quiz

- **Loading Step** `quiz-loading-step` — Add one line of progress text to a quiz loading animation, with an optional checkpoint. · content · inside Quiz Loading Animation · holds accents
- **Popup Checkpoint** `quiz-loading-popup` — Pause a quiz loading animation on a dialog and wait for the shopper to choose. · content · inside Loading Step
- **Quiz Answer** `quiz-answer` — Add one answer to a quiz question, with an optional icon, image, second line and customer tag. · content · inside Quiz Answers
- **Quiz Answers** `quiz-answers` — Ask a quiz question with text, icon or image answers, in a stack or a grid. · holding + content · inside Quiz Content · holds Quiz Answer
- **Quiz Content** `quiz-content` — Hold the blocks that make up one quiz step, optionally shown only to shoppers on one answer's path. · holding + content · inside Container, Quiz Loading, Quiz Page · holds content blocks
- **Quiz Email** `quiz-email` — Collect an email, a name or a typed answer in a quiz, and sign the shopper up with the tags their answers earned. · content · inside Quiz Content
- **Quiz Loading Animation** `quiz-loading-animation` — Run a checklist, spinner or progress bar while a quiz loading step plays. · holding · inside Quiz Content · holds Loading Step
- **Quiz Scale** `quiz-scale` — Ask a rating question as points along a track, a slider, or a picture slider. · holding + content · inside Quiz Content · holds Scale Point
- **Scale Point** `quiz-scale-point` — Add one point to a quiz rating scale, with an optional label, picture and customer tag. · content · inside Quiz Scale
- **Summary Stat** `quiz-summary-stat` — Add one figure to a quiz summary's stat grid, with an icon, a value and a label. · content · inside Quiz Summary

### Reviews

- **Amazon Review** `amazon-review` — Show one review in the style of an Amazon listing, with stars, a verified purchase tag and optional photos. · content
- **Avatar** `avatar` — Credit a quote, review or article to a person with their photo, name and an optional verified badge. · content
- **Avatar Orbit Circles** `avatar-orbit-circles` — Surround a large center photo with up to eight smaller avatars on dashed orbits, with optional rotation. · content
- **Facebook Comment** `facebook-comment` — Add one comment to a Facebook Comments thread, with reactions, plus optional media and up to three replies. · content · inside Facebook Comments
- **Facebook Comments** `facebook-comments` — Recreate a Facebook comment thread, with reactions, expandable replies and a comment box, for advertorial-style social proof. · holding · holds Facebook Comment
- **Filter Tabs** `testimonial-filter` — Add topic tabs above a testimonial grid to narrow its reviews to one topic, such as shipping. · content · inside Testimonial Grid
- **Review Avatars** `review-avatars` — Show a row of overlapping customer photos beside a line such as Rated 4.9/5 by, with optional stars. · content
- **Review Stars** `review-stars` — Show a star rating with a line such as 1,200 reviews, optionally scrolling to the reviews when tapped. · content · holds accents
- **Testimonial Grid** `testimonial-grid` — Display customer reviews as a grid of cards, with optional sorting, filter tabs, masonry packing or a scrolling wall. · holding · holds Testimonial blocks and their controls
- **Testimonial Slider** `testimonial-slider` — Move customer reviews through a carousel, one or several cards at a time, with optional autoplay or a marquee. · holding · holds Testimonial

### Row

- **Row Image** `row-image` — Place an image in a row beside other blocks, at its own width on desktop and mobile. · content · inside Row, Slide

### Sliders & Grids

- **Bento Grid** `bento-grid` — Arrange image cards of mixed widths into a mosaic, with text below or over each image. · holding · holds Bento Item
- **Bento Item** `bento-item` — Add one image card to a bento grid at its own width, with an optional badge and link. · content · inside Bento Grid
- **Grid** `grid` — Lay out a set of equal cards, such as features, stats, or steps, in columns that wrap into rows. · holding · holds Grid Item
- **Grid + Mobile Slider** `grid-mobile-slider` — Show items in a desktop grid that turns into a swipeable slider on mobile instead of a long stack. · holding · holds Grid Item
- **Grid Item** `grid-item` — Hold the blocks for one card of a grid, which sets the padding, colors, and border for every card. · holding · inside Grid, Grid + Mobile Slider · holds content blocks
- **Image Background** `slide-image-bg` — Layer a background image behind one slide or grid item, with an optional overlay to keep text readable. · content · inside Grid Item, Slide
- **Slide** `slide` — Hold the blocks for one slide of a slider, which sets the padding and colors for every slide. · holding · inside Slider · holds content blocks
- **Slider** `slider` — Show content in a swipeable carousel, one or several slides at a time, with optional autoplay. · holding · holds Slide
- **Slider Arrows** `slider-arrows` — Page through the nearest slider with arrows placed anywhere in the section, such as beside its heading. · content
- **Slider Thumbnails** `slider-thumbnails` — Let shoppers jump between slides of the nearest slider by tapping image or icon thumbnails. · content

### Social Proof

- **Logo** `as-seen-on-logo` — Place one brand logo in an As Seen On strip, sized against the others, with an optional quote. · content · inside As Seen On

### Sticky

- **Desktop Bar** `sticky-product-desktop` — Follow desktop shoppers with a product bar carrying the image, title, price, selectors, and an add-to-cart button. · content · inside Sticky Product · holds accents
- **Mobile Bar** `sticky-product-mobile` — Follow mobile shoppers with a product bar in one row or two, with optional selectors on the second. · content · inside Sticky Product · holds accents
- **Sticky Badge** `sticky-product-badge` — Label a sticky bar with a small badge on its outer edge or centered inside it. · content · inside Desktop Bar, Mobile Bar
- **Sticky Buy Button** `sticky-buy-button` — Float a single add-to-cart button over the page, with no bar behind it, on either device or both. · content · inside Sticky Product · holds accents

### Support

- **FAQ Category** `faq-category` — Group questions under one tab of the FAQ section, with an optional icon beside the tab name. · holding + content · inside FAQ · holds FAQ Item
- **FAQ Item** `faq-item` — Add one question and its answer to an FAQ category, shown as a row that expands when tapped. · holding + content · inside FAQ Category · holds 3 kinds of block

### Tabs & Accordions

- **Collapsible Heading Badge** `collapsible-row-heading-badge` — Add a small label such as NEW or FREE to a collapsible row's heading. · content · inside Collapsible Row, Collapsible Row Item
- **Collapsible Heading Icon** `collapsible-row-heading-icon` — Add an icon or small picture before a collapsible row's heading, such as an ingredient photo. · content · inside Collapsible Row, Collapsible Row Item
- **Collapsible Row** `collapsible-row` — Hide content behind a heading that expands when tapped, such as a returns policy or a footer menu. · holding + content · holds content blocks
- **Collapsible Row Item** `collapsible-row-item` — Add one row to a collapsible row list, carrying its own heading and content. · holding + content · inside Collapsible Row List · holds content blocks
- **Collapsible Row List** `collapsible-row-list` — Stack collapsible rows that share one style, such as product details in a buy box or a short FAQ. · holding + content · holds Collapsible Row Item and Colors
- **Colors** `collapsible-row-colors` — Color a collapsible row's header, border and panel, resting or expanded, from one base color or a color scheme. · content · inside Collapsible Row, Collapsible Row List
- **Folder Tabs** `folder-tabs` — Switch between panels of content from file-folder tabs raised out of a bordered box. · holding · holds Tab
- **Tab** `tab` — Hold one panel's label, optional icon, and content blocks inside a tabs parent. · holding + content · inside Folder Tabs, Tabs, Underline Tabs · holds content blocks
- **Tabs** `tabs` — Switch between panels of content from a row of tabs, such as one comparison or gallery per product. · holding · holds Tab
- **Underline Tabs** `underline-tabs` — Switch between panels of content from a row of tabs marked by a sliding underline. · holding · holds Tab

### Templates

- **Cart Gift Picker** `cart-gift-picker` — Let shoppers pick a free gift in the cart once it reaches a total, an item count, or a progress bar goal. · holding + content · inside Body, Cart Page · holds Gift Choice
- **Cart Subtotals** `sugar-cart-subtotals` — Show the savings, applied discounts, subtotal and an optional total under the cart's items. · content · inside Cart Page, Footer
- **Cart Toggles** `cart-toggles` — Offer up to 2 add-ons in the cart footer as a switch or checkbox, such as shipping protection. · content · inside Cart Page, Footer
- **Checkout Button** `cart-checkout-button` — Send the shopper to checkout with a full-width button that carries the cart total. · content · inside Cart Page, Footer · holds accents

### Text

- **Credits** `footer-credits` — Show the footer's copyright line with the store name, policy links and the payment methods the store accepts. · content
- **Disclaimer** `footer-disclaimer` — Add fine print, such as an FDA supplement disclaimer, to a footer or under a buy box. · content
- **Link Menu** `link-menu` — Show a list of links under an optional heading, from a Shopify menu or built by hand. · holding + content · holds Link
- **Text** `text` — Add paragraphs of rich text with sizes per device and inline accents. · holding + content · holds Highlight Emoji and Rotating Text
- **Text Banner** `text-banner` — Set a line of text on its own colored strip, such as a shipping note, optionally flush to a card's top or bottom. · content

### Text Accents

- **Inline Countdown** `inline-countdown` — Show a live countdown inside a heading or text, wherever [countdown] is typed. · content
- **Inline Icon** `inline-icon` — Place an icon inside a heading or text, wherever its [icon_1] to [icon_4] placeholder is typed. · content · inside Heading, Heading + Text, Text

### Urgency

- **Countdown Timer** `countdown-timer` — Count down to a date, to midnight or from each visitor's first visit, to add urgency to an offer. · content
- **Inventory Pulse** `inventory-pulse` — Show a stock status beside a pulsing dot, optionally switching to a low-stock message from real inventory. · content · holds accents

### Utility

- **Button** `drawer-button` — Add a button to the header drawer, such as Shop now or Take the quiz. · content · inside Mobile Drawer
- **Country & Language** `localization` — Let shoppers switch country and language from a dropdown, such as in the footer. · content
- **Image** `drawer-image` — Add a picture card to the header drawer or a desktop mega menu, such as a featured collection. · content · inside Menu, Mobile Drawer
- **Link** `desktop-link` — Add one link to a hand-built desktop menu, with optional Links inside for a dropdown or mega menu. · holding + content · inside Link, Menu · holds Link
- **Link** `drawer-link` — Add one link to a hand-built drawer menu, with an optional icon, such as Track your order. · holding + content · inside Link, Menu · holds Link
- **Menu** `desktop-menu` — List the desktop header's navigation, with list dropdowns or a full-width mega menu of columns and cards. · holding + content · inside Desktop Layout · holds Link and Image
- **Menu** `drawer-menu` — List a navigation in the header drawer, with accordions, slide-in panels, cards or tabs. · holding + content · inside Mobile Drawer · holds Link

## Concepts

How the theme works beyond any one component. Fetch the full guide from the Sugar Theme MCP by slug (`get_concept`).

- **Buttons** `buttons` — Style every button with one of four theme-wide choices, two filled and two outlines that follow the section.
- **Colors** `colors` — Set colors through a brand palette, color schemes for whole surfaces, and optional per-element overrides.
- **Comparison tables** `comparison-tables` — Choose between seven ready-made comparison tables and a custom table, by what each cell needs to say.
- **Conditional cart content** `conditional-cart-content` — Show or hide blocks in the cart drawer based on what the shopper has already added.
- **Corners** `corners` — Round media, containers, badges and buttons from four theme values, with an optional override on any component.
- **Landing layout** `landing-layout` — Build ad and campaign pages on a stripped-down layout that skips the header, footer, cart and product engines.
- **License** `license` — Find the license key, see what the theme carries instead, and move the license to another store.
- **Quizzes** `quizzes` — Build a multi-step quiz from a shell section and one section per step, with optional branching paths.
- **Right to left** `right-to-left` — Run the theme on a right-to-left storefront, such as Hebrew or Arabic, with no setting or app.
- **Tablets** `tablets` — Fit desktop layouts to tablets automatically, with text, badges and card rows that shrink to the screen.
- **Template size limit** `template-size-limit` — Keep a template under Shopify's 512 KB limit by removing hidden blocks, old test versions and repeated content.
- **Theme editor** `theme-editor` — Edit copy in the theme editor and see it in the preview as you type, without waiting for the section to reload.
- **Typography** `typography` — Give the theme a heading font, a body font and an optional accent font that every block reads.
