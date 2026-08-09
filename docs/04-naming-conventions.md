# Why Things Are Named the Way They Are

Naming isn't random in this project - each language/layer follows the
convention its own community expects, so the code "reads normally" to
someone used to that language.

## JavaScript: `camelCase`

```js
let albumId, searchTerm, isLoggedIn, favouriteIds;
function loadAlbums() { ... }
```

Standard JavaScript style is `camelCase` (first word lowercase, each
following word capitalised, no underscores). Every variable and function
in `js/*.js` follows this.

## PHP: also `camelCase` for variables (deliberately)

```php
$albumId = (int) ($_GET['id'] ?? 0);
$loggedInUser = current_user();
```

Older PHP code often uses `snake_case` for variables, but this project
uses `camelCase` in PHP too. Two reasons: modern PHP style guides
(PSR-12) allow either and increasingly favour camelCase, and - more
importantly for this project - the *same* piece of information often
travels between PHP and JS (e.g. an album id), so keeping the variable
name spelled the same way in both places (`albumId` in JS, `$albumId` in
PHP) makes it easier to trace a value's journey through the app when
explaining it out loud.

**PHP function names are the one exception** - `is_logged_in()`,
`current_user()`, `require_login()` use `snake_case`. That's because
they're modelled on PHP's own built-in functions (`password_hash()`,
`htmlspecialchars()`, `array_rand()`), which are all `snake_case` - so
our own helper functions blend in with the language's standard library
instead of looking out of place next to it.

## Database columns and SQL: `snake_case`

```sql
album_id, user_id, review_text, cover_color_1, created_at
```

This is universal SQL convention (and it's what phpMyAdmin/MySQL tools
show by default), so the raw column names stay `snake_case` even though
the PHP variables that hold their values are `camelCase`:

```php
$stmt->execute(['user_id' => $userId, 'album_id' => $albumId]);
//               ^ SQL/column style      ^ PHP variable style
```

That mismatch is intentional, not sloppy - it's the seam where "PHP
world" meets "database world," and it's worth pointing out in the viva
as evidence of understanding *why* a convention exists, not just
following it blindly.

## Common name prefixes/patterns used throughout

- **`is`/`has` prefix for booleans** - `isLoggedIn`, `isFavourited`,
  `is_admin`. Reading a variable named `isFavourited` out loud already
  tells you it's a true/false question, without needing to check its
  type.
- **`my` prefix for "belongs to the current session user"** -
  `myRating`, `myReviewText`, `myReviewId` on the album page, versus
  plain `reviews` for the full public list. This distinguishes "the
  form I'm about to submit" from "everyone else's reviews I'm just
  displaying."
- **`Stmt` suffix for a prepared statement object**, as opposed to the
  plain variable holding the *result* of running it - e.g.
  `$existingStmt` (the prepared query) versus `$existing` (the row it
  found, or `false` if none).
- **Function names are verbs; component/prop names are nouns** -
  `loadAlbums()`, `toggleFavourite()`, `submitReview()` describe an
  action; `rating`, `modelValue`, `album` describe a piece of data.
- **`e()`** is a deliberately short name (see
  [03-php-and-database-basics.md](03-php-and-database-basics.md)) for
  the escaping helper, since it gets called dozens of times per page and
  a long name would clutter every line it appears on. This mirrors a
  common convention in other PHP frameworks (Laravel's Blade templates
  use `e()` for exactly the same purpose).
