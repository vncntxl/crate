# Security Cheat Sheet (viva-relevant concepts)

A single-page summary of every security idea in Crate, with exactly
where to point in the code for each one.

## 1. Prepared statements (SQL injection prevention)

**Every** database query in the project uses a PDO prepared statement
with named placeholders (`:id`, `:user_id`, and so on), never string
concatenation. See [03-php-and-database-basics.md](03-php-and-database-basics.md)
for the full explanation. `includes/db.php` also sets
`PDO::ATTR_EMULATE_PREPARES => false`, which forces PHP to send the
query and the values to MySQL as two separate steps (true prepared
statements) instead of faking it by building the final SQL string
itself.

## 2. Password hashing

`password_hash()` (bcrypt) in `register.php`, `password_verify()` in
`login.php` and `api/password_change.php`. Passwords are never stored or
compared in plain text.

## 3. Output escaping (XSS prevention)

The `e()` helper in `includes/auth.php`, used wherever a user-typed
value is printed back into HTML: names, emails, on every page. Vue
templates get this for free too. `{{ }}` interpolation escapes
automatically, so text like `<script>` typed into a review shows up as
literal text on screen, not as running code.

## 4. Sessions and login state

`session_start()`, `$_SESSION['user_id']`, and `session_regenerate_id(true)`
after login/register defend against session fixation (see
[03-php-and-database-basics.md](03-php-and-database-basics.md)).
`includes/auth.php` also self-heals a **stale session**. If
`current_user()` looks up `$_SESSION['user_id']` and finds no matching
row (the account was deleted, say), it clears the session instead of
leaving the browser in a broken "logged in as nobody" state.

## 5. Every write endpoint checks login first

Every file in `api/` that changes data (`review_add.php`,
`review_delete.php`, `favourite_toggle.php`, `account_update.php`,
`password_change.php`, `album_add.php`) starts with:

```php
if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['error' => '...']);
    exit;
}
```

Anyone can call these URLs directly with curl, Postman, or browser
devtools, completely bypassing the Vue front end. The front end hiding a
button is a convenience for honest users. This check is what actually
stops a dishonest one.

## 6. Ownership checks

Whenever an endpoint changes or deletes a specific row, the *session's
own user id* is part of the `WHERE` clause, not just used to decide
whether to run the query at all:

```php
// api/review_delete.php
$stmt = db()->prepare('DELETE FROM reviews WHERE id = :id AND user_id = :user_id');
$stmt->execute(['id' => $reviewId, 'user_id' => $userId]);
```

Send another user's review id and this matches **zero rows** instead of
deleting a review that isn't yours. The database itself enforces the
boundary, not just an `if` statement earlier in the file. The same
pattern appears in `api/review_add.php` (updates),
`api/favourite_toggle.php`, and `api/account_update.php`.

## 7. Admin checks happen on the server

`includes/auth.php`'s `require_admin()` is called at the very top of
`admin.php`, and `api/album_add.php` independently re-checks
`current_user()['is_admin']` before inserting anything. The "Admin" link
only appearing in the nav for admin users (`includes/header.php`) is
just a UI nicety. The real gate is these two server-side checks, which
still stop a non-admin who typed the URL in directly or posted to the
API with curl.

## 8. Client-side validation vs. server-side validation

Every form (register, login, add a review, add an album) has HTML
attributes like `required` and `minlength`, and some pages add extra
JavaScript checks, e.g. `admin.js`'s `validate()`. **None of this is the
real security boundary.** It only runs in the visitor's own browser,
which they fully control: devtools can delete a `required` attribute in
seconds, and curl doesn't run JavaScript at all. Every one of those same
rules gets checked again, from scratch, in the matching `api/*.php` file
or PHP form handler. Client-side validation exists purely for a fast,
friendly experience, instant feedback with no round trip to the server
for an obviously empty field. Server-side validation exists because it's
the only check that can't be bypassed.

## 9. Unique constraints as a second line of defence

The `reviews` table has a `UNIQUE KEY (user_id, album_id)` constraint,
added specifically so "one review per user per album" is a rule the
*database* enforces, not just something `api/review_add.php`'s
application logic happens to get right. Even if a future code change
introduced a bug that skipped the "does a review already exist?" check,
the database would still refuse a duplicate insert.
