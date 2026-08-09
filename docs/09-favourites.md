# Favourites

**Files:** `collection.php`, `js/collection.js`, `api/favourites.php`, `api/favourite_toggle.php`, plus the heart button on `index.php`/`album.php`

## A naming note worth explaining upfront

The feature is called "favourites" everywhere a user sees it (nav link,
page heading, button labels), but the actual database table is called
`collection` - that's simply the name it already had in the database
before this feature was built (see the note in
[01-big-picture.md](01-big-picture.md) about adapting to the schema as
it actually exists). It's completely normal for a table name and a
feature name to differ slightly; what matters is that the code is
consistent about it, which it is - every query against that table lives
inside `api/favourites.php` and `api/favourite_toggle.php`, so there's
exactly one place that needs to know the real table name.

## Toggling: one endpoint, two directions

```php
$existing = ...  // is there already a row for this user_id + album_id?

if ($existing) {
    // DELETE it - un-favouriting
} else {
    // INSERT one - favouriting
}
```

"Toggle" means the front end doesn't need to know or track whether an
album is currently favourited before calling this - it just always
calls the same endpoint, and reads `favourited: true`/`false` back from
the response to find out what actually happened.

## Class binding for the heart icon

```html
<button :class="{ favourited: favouriteIds.includes(album.id) }" @click.stop.prevent="toggleFavourite(album.id)">♥</button>
```

`:class="{ favourited: ... }"` is the exact same technique as the genre
chips' `active` class (see [02-vue-basics.md](02-vue-basics.md)) - Vue
adds the CSS class `favourited` only when the condition is true, and
`css/style.css` colours that class pink. No manual DOM manipulation.

`favouriteIds` is a plain array of album ids, loaded once via
`api/favourites.php` when the page mounts. Checking `.includes(album.id)`
for every card is simple and fast enough at this scale (a handful of
albums per page); a much larger catalogue might use a `Set` instead for
faster lookups, but the difference wouldn't be noticeable here.

## Why `@click.stop.prevent`

On the home page, the heart button lives *inside* the album's `<a>`
link. Without `.stop.prevent`:

- `.prevent` missing → clicking the heart would also follow the link and
  navigate to the album page.
- `.stop` missing → the click would "bubble up" to the `<a>` and trigger
  its own click behaviour too.

Both modifiers together mean clicking the heart *only* toggles the
favourite and does nothing else. See
[02-vue-basics.md](02-vue-basics.md) for how event modifiers work in
general.

## The favourites page itself (`collection.php`)

Guarded by `require_login()` - there's no logged-out version of this
page to render, so it doesn't try to have one. Every heart button on
this page is already favourited, so clicking one only ever means
"remove," and `js/collection.js`'s `removeFavourite()` filters the item
straight out of the local `albums` array instead of re-fetching the
whole list from the server - a small optimisation since we already know
exactly what changed.
