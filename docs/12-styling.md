# Styling and Cover Art

**Files:** `css/style.css` (one stylesheet, shared by every page), `seed/fetch_covers.php`

## Where the cover art comes from

Every album has a real cover image, stored as an ordinary JPEG in
`assets/covers/`, with its path saved in the `albums.cover_url` column.
Those files were downloaded once by `seed/fetch_covers.php`, a setup
script that is never run by the live website.

That script asks Apple's free iTunes Search API for each album (no
account or API key needed), and uses the response to fill in the title,
artist, release year, track count and artwork. Two details in it are
worth being able to explain:

- **It picks the result by exact match, not the first hit.** Searching
  "Taylor Swift 1989" returns the *Taylor's Version* deluxe edition
  first, and "Tame Impala Currents" returns a remix EP. The script
  fetches 20 results and keeps only the one whose normalised title *and*
  artist both match what was asked for, or reports a skip.
- **It downloads the artwork rather than hotlinking it.** The API gives
  back a URL to a 100x100 thumbnail; swapping the size in that URL asks
  Apple's image server for a 600x600 version. The script saves that file
  locally, so the running site serves its own images and doesn't depend
  on Apple being reachable when a marker opens the page.

## The gradient fallback

Each album also keeps `cover_color_1` and `cover_color_2` (hex colours
like `#ff6b6b`). Those render as a CSS gradient underneath the artwork:

```html
:style="{ background: 'linear-gradient(135deg, ' + album.cover_color_1 + ', ' + album.cover_color_2 + ')' }"
```

This is a **style binding**: the same `:` (short for `v-bind`) syntax
used for `:href` and `:class` elsewhere, except here it sets an inline
`style` attribute directly from data instead of a plain string. The
gradient matters because an album added through the admin form has no
artwork, so `cover_url` is null and the `<img>` is skipped by its
`v-if`. Rather than an empty square, that album gets a coloured tile.

The images themselves use `object-fit: cover`, which crops a non-square
image to fill the square tile instead of stretching it out of shape.

## Cache busting on CSS and JS

Browsers cache `.css` and `.js` files aggressively. That is normally
what you want, but it means an updated file can keep serving the old
version after a deploy, which is genuinely confusing to debug: the HTML
changes but the JavaScript driving it does not.

The `asset()` helper in `includes/auth.php` puts the file's
last-modified time on the end of its URL:

```php
<script src="<?= asset('js/app.js') ?>"></script>
<!-- renders as: js/app.js?v=1786280407 -->
```

Edit the file and `filemtime()` changes, so the URL changes, so the
browser treats it as a new file and fetches it. Leave the file alone and
the URL stays stable and stays cached. This happened for real during
development: the browser kept running an old `app.js` against new HTML,
and the page silently ignored a newly added button.

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
