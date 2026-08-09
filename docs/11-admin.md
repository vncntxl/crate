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
everywhere, because `admin.php` and `api/album_add.php` can be reached
independently. Someone could, in principle, `POST` straight to the API
without ever loading the admin page. Neither check trusts the other;
each protects itself. The "Admin" link only appearing in the nav for
admin users (`includes/header.php`) is a third layer, but it's the
*weakest* one. It's just hiding a link, easily bypassed by typing the
URL directly, which is exactly why the two real checks above exist. See
[05-security-concepts.md](05-security-concepts.md), point 7.

## Client-side validation, and why it isn't enough on its own

`js/admin.js` has a `validate()` method that checks title, artist, and
genre aren't blank and the year is sensible, purely so a user gets
instant feedback without waiting on a network round trip.
`api/album_add.php` then checks every one of those same rules again from
scratch, because the JavaScript check runs entirely inside the visitor's
own browser. Anyone can disable it, edit it, or skip the form entirely
and `POST` directly to the endpoint with curl. See
[05-security-concepts.md](05-security-concepts.md), point 8, for the
general principle.

## Cover art for admin-added albums

The seeded albums have real cover images, downloaded once by
`seed/import_albums.php` (see [12-styling.md](12-styling.md)). The admin
form has an optional **Cover image URL** field so a newly added album can
have artwork too, with a live preview next to the field that catches a
mistyped address before saving.

Leave it blank and `cover_url` stays null, the `<img>` is skipped by its
`v-if`, and `api/album_add.php` falls back to a random gradient from a
small fixed palette:

```php
$palette = [['#ff6b6b', '#ff9f7f'], ['#4d7dff', '#7fb2ff'], ...];
$colors = $palette[array_rand($palette)];
```

### Why the URL is validated on the server

The value ends up inside `<img :src="album.cover_url">` on the front end.
An attribute binding will happily accept a `javascript:` URL, so without
a check an admin could store one and turn saved data into running code.
`api/album_add.php` therefore accepts only real `http` and `https`
addresses:

```php
$scheme = strtolower((string) parse_url($coverUrl, PHP_URL_SCHEME));

if (!filter_var($coverUrl, FILTER_VALIDATE_URL) || !in_array($scheme, ['http', 'https'], true)) {
    $errors[] = 'Cover image URL must start with http:// or https://';
}
```

The browser's own `type="url"` input does a similar check, but as always
that only protects a cooperative visitor. The server check is the one
that counts.

### Why not file uploads

Accepting uploaded image files would mean validating file types, imposing
storage limits, and defending against someone uploading a PHP script
renamed to `.jpg` and then requesting it. Taking a URL sidesteps that
entire class of problem, which is the right trade-off at this scale.
