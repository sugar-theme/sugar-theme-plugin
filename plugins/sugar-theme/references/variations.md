# Variations

How to build several versions of a block, section or page so the user can flip between them on their real page before choosing one.

# Purpose

A description of a section or component is often not enough for a person to decide on. Seeing and interacting with different variations lets them make a definite, satisfying decision, and lets design ideas be merged or spawned that weren't clear before.

Variations are built **on the theme, in context, in one file**. Not as a separate HTML mockup: a mockup can't run Liquid or the theme's real styles, the user can't see it next to the rest of their page, and the winner would have to be built a second time. Built on the theme, the winner is already built.

# Step 1: Analyze

Review the user's original request in its entirety. Extract the result they want, even when it is ambiguous. Zoom out to the purpose of the component: a variation is a different way to convey the same message, not a different message.

# Step 2: Ideate

Devise several design directions for the task. The goal is to explore genuinely different directions the user can review, pick between, and combine.

Variations should be carefully crafted and considered. Do not create a variation for the sake of creating one. Each should have its own strengths, its potential weaknesses and a clear reason to exist. Three is the usual number; two is fine when the choice is binary, and more than four is rarely useful.

Every variation is built in the user's fonts, colors and corner settings, read from the working theme. The user is choosing between layouts and ideas, not between brands.

# Step 3: Scaffold

## In context (the default)

Use this whenever the target already exists: a product page, a landing page, a section the user wants variations of.

1. **Duplicate the target template** on the working theme, adding a `variations` suffix: `templates/product.json` becomes `templates/product.variations.json`, `templates/page.landing.json` becomes `templates/page.landing.variations.json`. Never edit the real template. The copy is viewed on the same product or page by adding `?view=variations` to its URL, so the user sees their real product, header, media and everything around the variation.
2. **Place each variation where it would live**, wrapped in a **Container** block whose Anchor ID is `sugar-var-1`, `sugar-var-2`, and so on. The Container is allowed inside almost every host and renders the anchor as its element ID, which is what the switcher uses. For variations of a whole section, use the section's own Anchor ID instead of a wrapper.
3. **Add one Custom Liquid section as the first section in the template's `order`**, with all four padding values set to `0`, holding the switcher below. It shows one variation, hides the rest before the page paints so nothing flashes, and draws a fixed pill at the bottom of the screen to flip between them. Set `n` to the number of variations and edit the pill's labels.

```html
<script>(function(){var q=new URLSearchParams(location.search),v=q.get('variation')||'1',n=3;if(v!=='all'){var css='';for(var i=1;i<=n;i++){if(String(i)!==v)css+='#sugar-var-'+i+'{display:none!important}'}var s=document.createElement('style');s.textContent=css;document.head.appendChild(s)}document.addEventListener('DOMContentLoaded',function(){var b=document.getElementById('sugar-var-bar');if(!b)return;b.querySelectorAll('a').forEach(function(a){if(a.getAttribute('data-v')===v){a.style.background='#3F89F1';a.style.fontWeight='700'}})})})();</script><style>@media (max-width:749px){#sugar-var-bar>span{display:none}#sugar-var-bar{max-width:calc(100vw - 24px);overflow-x:auto;scrollbar-width:none}}</style><div id="sugar-var-bar" style="position:fixed;left:50%;bottom:16px;transform:translateX(-50%);z-index:9999;display:flex;gap:4px;align-items:center;padding:6px 8px;border-radius:999px;background:#111;color:#fff;font:500 13px/1 system-ui,sans-serif;white-space:nowrap;box-shadow:0 8px 24px rgba(0,0,0,.25)"><span style="opacity:.55;padding:0 8px">Variation</span><a data-v="1" href="?view=variations&amp;variation=1" style="padding:8px 14px;border-radius:999px;text-decoration:none;color:#fff">1 · Table</a><a data-v="2" href="?view=variations&amp;variation=2" style="padding:8px 14px;border-radius:999px;text-decoration:none;color:#fff">2 · Cards</a><a data-v="3" href="?view=variations&amp;variation=3" style="padding:8px 14px;border-radius:999px;text-decoration:none;color:#fff">3 · Side by side</a><a data-v="all" href="?view=variations&amp;variation=all" style="padding:8px 14px;border-radius:999px;text-decoration:none;color:#fff">All</a></div>
```

The `All` link shows every variation stacked, for side-by-side comparison. If the duplicated template uses a different suffix, change `view=variations` in the links to match.

## In isolation

Use this only when the thing has no home yet: a brand new page, or a section the user hasn't placed. Create a page template whose first section is Hide Header & Footer with all three hides on, then add the switcher and the variations exactly as above. Create an unlisted page (published, not in any menu) that uses the template, and delete the page along with the template afterwards.

## Before delivery

Validate the template before pushing it: every range value inside its setting's limits and on its step, every block type allowed by its parent. An invalid value doesn't error; the template silently breaks. Then open the page and test every variation, in both viewports and both browsers, exactly as for a normal build. Check the pill: it must not cover the end of the last variation, so give the section enough bottom padding.

# Step 4: Deliver

Hand the user a theme editor deep link to the variations template on their page:

```
https://STORE.myshopify.com/admin/themes/THEME_ID/editor?previewPath=%2Fproducts%2FHANDLE%3Fview%3Dvariations
```

In the editor they see the full page, the pill flips between variations inside the preview, and the sidebar lists the variations as Containers they can open and adjust themselves. Name each variation in one line so they know what they are looking at.

# Optional: Revisions

The user may ask for changes, or for elements of several variations to be merged. Make the edits on the variations template and deliver the same link again.

# Step 5: Implement

Once the user has chosen, move the winning block into the real template at the same position, unwrapped from its Container unless the Container was doing work. Test it there once more; the real template can differ from the copy if the user edited it meanwhile.

# Step 6: Hygiene

Delete the variations template from the theme. For freestyle variations, delete the losing files too, and log the winner in the project's `custom-sections-blocks.md`. In isolation mode, delete the page as well. A variations template left behind is clutter in the editor's template list and a stale copy waiting to confuse the next agent.

# Gotchas

These were found building the reference scaffold; do not rediscover them.

- A `position: sticky` switcher gets trapped inside its own section's wrapper and stops following the scroll. Use `fixed`.
- Keep `white-space: nowrap` on the pill, or its labels wrap into three lines on a phone.
- Below 750px the pill is wider than the screen unless the "Variation" label is hidden and the pill can scroll; the style block above does both.
- The switcher must be the first section in `order`. Its style is written before the variations parse, which is what prevents the flash of all three appearing at once.
- Container is the wrapper because it is allowed almost everywhere and renders the Anchor ID as its element ID. A block without an Anchor ID setting can't be targeted directly.
