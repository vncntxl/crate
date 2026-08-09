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
`seed/fetch_covers.php` (see [12-styling.md](12-styling.md)). An album
added through this admin form has no artwork, so its `cover_url` stays
null and the `<img>` on the card is skipped by its `v-if`.

To make sure a new album still looks like something rather than an empty
square, `api/album_add.php` assigns it a random gradient from a small
fixed palette:

```php
$palette = [['#ff6b6b', '#ff9f7f'], ['#4d7dff', '#7fb2ff'], ...];
$colors = $palette[array_rand($palette)];
```

Handling real image uploads would mean file validation, storage limits
and a whole class of security problems (someone uploading a PHP script
disguised as a `.jpg`), which is well outside what this assignment
needs. The gradient is the deliberate trade-off.
