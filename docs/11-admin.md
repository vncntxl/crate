# Admin: Add an Album

**Files:** `admin.php`, `js/admin.js`, `api/album_add.php`

## Two independent gates, not one

```php
// admin.php
require_admin();   // 1. server-side page gate
```

```php
// api/album_add.php
$user = current_user();
if (!$user || !$user['is_admin']) {   // 2. server-side API gate
    http_response_code(403);
    ...
}
```

These are separate checks in separate files, not one check reused
everywhere - because `admin.php` and `api/album_add.php` can be reached
independently (someone could, in principle, `POST` straight to the API
without ever loading the admin page). Neither one trusts the other; each
protects itself. The "Admin" link only appearing in the nav for admin
users (`includes/header.php`) is a third layer, but it's the *weakest*
one - it's just hiding a link, easily bypassed by typing the URL
directly, which is exactly why the two real checks above exist. See
[05-security-concepts.md](05-security-concepts.md), point 7.

## Client-side validation, and why it isn't enough on its own

`js/admin.js` has a `validate()` method that checks title/artist/genre
aren't blank and the year is sensible, purely so a user gets instant
feedback without waiting on a network round trip. `api/album_add.php`
then checks every one of those same rules again from scratch, because
the JavaScript check runs entirely inside the visitor's own browser -
anyone can disable it, edit it, or skip the form entirely and `POST`
directly to the endpoint with curl. See
[05-security-concepts.md](05-security-concepts.md), point 8, for the
general principle.

## Placeholder cover art

Albums don't have real cover images in this project - each one gets a
two-colour CSS gradient instead (`cover_color_1`/`cover_color_2`, used
throughout via `:style="{ background: 'linear-gradient(...)' }"`). New
albums get a random pair from a small fixed palette so they look
consistent with the seeded demo data:

```php
$palette = [['#ff6b6b', '#ff9f7f'], ['#4d7dff', '#7fb2ff'], ...];
$colors = $palette[array_rand($palette)];
```

See [12-styling.md](12-styling.md) for why this project uses gradients
instead of uploaded images.
