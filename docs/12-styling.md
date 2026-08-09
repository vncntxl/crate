# Styling

**File:** `css/style.css` (one stylesheet, shared by every page)

## Why album covers are gradients, not images

The `albums` table has `cover_color_1` and `cover_color_2` columns (hex
colours like `#ff6b6b`), not a `cover_url`. Every place an album is
shown, the grid and the detail page, renders those two colours as a CSS
gradient instead of an `<img>`:

```html
:style="{ background: 'linear-gradient(135deg, ' + album.cover_color_1 + ', ' + album.cover_color_2 + ')' }"
```

This is a **style binding**: the same `:` (short for `v-bind`) syntax
used for `:href` and `:class` elsewhere, except here it sets an inline
`style` attribute directly from data instead of a plain string. It's a
deliberate design already baked into the seed data, with a real
advantage for a student project. There's no dependency on an external
image API being reachable at grading time, no broken-image icons if a
URL goes stale, and no upload or storage handling to build. Every album
always has *something* visually distinct to show, generated instantly
from two hex codes already sitting in the database.

## CSS custom properties (variables)

```css
:root {
    --bg: #101018;
    --accent: #6d5df0;
    --border: #2a2a38;
    ...
}
```

Declaring colours once at the top and reusing them everywhere with
`var(--accent)` means the whole site's palette can be changed by editing
a handful of lines here, instead of hunting through every selector in
the file. It also documents intent. `var(--danger-text)` on an error
message is more meaningful at a glance than a bare `#ffb4c2`.

## Responsive layout

One breakpoint handles the two places the layout would otherwise break
on a small screen:

```css
@media (max-width: 700px) {
    .album-detail { grid-template-columns: 1fr; }  /* was 260px + 1fr */
    .site-nav { flex-direction: column; align-items: flex-start; }
}
```

The album grid itself (`index.php`, `collection.php`) doesn't need a
breakpoint at all. `grid-template-columns: repeat(auto-fill, minmax(180px, 1fr))`
already tells the browser to fit as many 180px-or-wider columns as the
screen allows, so it naturally goes from many columns on a wide screen
down to one on a narrow one without any extra rules.

## Focus states

```css
a:focus-visible, button:focus-visible, input:focus-visible, textarea:focus-visible {
    outline: 2px solid var(--accent);
}
```

`:focus-visible`, rather than plain `:focus`, shows the outline only
when the element was reached by keyboard (the Tab key), not when clicked
with a mouse. Someone navigating without a mouse can always see where
they are on the page, without every button getting a visible ring on
every click.
