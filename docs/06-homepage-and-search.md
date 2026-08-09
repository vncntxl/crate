# Home Page, Search, and Genre Filter

**Files:** `index.php`, `js/app.js`, `api/albums.php`, `api/genres.php`

## `api/albums.php`: the data source

One endpoint, three modes, decided by which query parameters are present:

```php
if ($q !== '') {
    // ?q=... -> search title OR artist with LIKE '%...%'
} elseif ($genre !== '') {
    // ?genre=... -> exact match on genre
} else {
    // no params -> 8 random albums, ORDER BY RAND() LIMIT 8
}
```

Search and genre-filter are **mutually exclusive** here. If `q` is
present, genre is ignored entirely. That single `elseif` is the whole
rule, and it's mirrored on the front end (below) so the UI never shows a
state that contradicts what the server would actually do.

## `index.php`: the shell

Just a `<div id="app">` with the search box, the genre chip buttons, and
a `v-for` grid of album cards. See
[02-vue-basics.md](02-vue-basics.md) for what each piece of that
template syntax means. The one PHP-specific trick on this page:

```php
<button v-if="<?= $loggedInUser ? 'true' : 'false' ?>" ...>♥</button>
```

PHP already knows whether you're logged in when it renders the page (it
ran `current_user()` inside `includes/header.php`), so it writes the
literal word `true` or `false` straight into Vue's `v-if` attribute. Vue
never has to work this out itself on the client side. It's baked into
the HTML before Vue even starts running.

## `js/app.js`: the logic

- `loadAlbums()` builds a `URLSearchParams` (either `?q=...` or
  `?genre=...`, or neither) and fetches `api/albums.php`.
- `onSearchInput()` runs on every keystroke in the search box. It clears
  `activeGenre` the moment you start typing, so a highlighted genre chip
  never lingers on screen while a search is actually what's filtering
  the results. This fixes a UI bug found during testing, where the chip
  originally stayed highlighted after typing.
- `filterByGenre(genre)` does the reverse: clicking a chip clears
  `searchTerm`.
- `mounted()` checks `window.location.search` for `?genre=Rock`. This is
  how clicking a genre in the nav dropdown, which is a plain
  server-rendered `<a href="index.php?genre=Rock">` rather than a Vue
  click handler, still ends up pre-filtering the grid once the page
  loads.
- `loadFavourites()` and `toggleFavourite()` are covered in
  [09-favourites.md](09-favourites.md).

## Why search fires on every keystroke instead of "debouncing"

A more polished version of this might wait around 300ms after the user
stops typing before firing the fetch, so a fast typist doesn't trigger
eight requests for "midnight" one letter at a time. This project keeps
it simple and fires immediately on every `@input`: correct, just not
maximally efficient. That's a reasonable, honest answer if asked "how
would you improve this?" in the viva.
