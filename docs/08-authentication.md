# Authentication: Register, Login, Logout

**Files:** `register.php`, `login.php`, `logout.php`, `includes/auth.php`

These three pages are plain HTML forms that `POST` to themselves - see
[01-big-picture.md](01-big-picture.md) for why they deliberately don't
use Vue/`fetch()` like the rest of the app.

## The shape every form-handling page follows

```php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 1. read $_POST values
    // 2. validate them, collecting messages into $errors
    // 3. if $errors is empty, do the real work and redirect away
}
// 4. if we get here (GET request, or POST with errors), render the form
```

The **same file** both shows the form and handles its submission. On a
first visit (`GET`), the `if` block is skipped entirely and the form
just renders empty. On submission (`POST`), it runs the checks; if
anything's wrong, it falls through to rendering the form again, this
time with `$errors` populated and the fields pre-filled with whatever
the user typed (`value="<?= e($name) ?>"`) so they don't have to retype
everything.

## `includes/auth.php` - the session toolkit

Four functions used everywhere else in the project:

- **`is_logged_in()`** - a fast, no-database check: is
  `$_SESSION['user_id']` set at all?
- **`current_user()`** - the real check. Looks up the full user row
  (name, email, `is_admin`) from the database, caches it for the rest of
  this page load, and **self-heals** a stale session (see
  [05-security-concepts.md](05-security-concepts.md), point 4) by
  clearing `$_SESSION['user_id']` if that id no longer matches any real
  user.
- **`require_login()`** - used at the top of pages that only make sense
  for a logged-in user (`account.php`, `collection.php`). Redirects to
  `login.php` and calls `exit` if nobody's logged in, so nothing below
  it in the file ever runs for a guest.
- **`require_admin()`** - `require_login()` plus an `is_admin` check,
  used only by `admin.php`.

`login.php` and `register.php` guard against an *already* logged-in
visitor seeing the form again with `if (current_user())` (not just
`is_logged_in()`) specifically so that check also triggers the
self-healing described above.

## Registering

```php
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
db()->prepare('INSERT INTO users (name, email, password) VALUES (...)')
    ->execute([...]);

$_SESSION['user_id'] = (int) db()->lastInsertId();
session_regenerate_id(true);
```

Validation before any of this runs: name isn't blank, email passes
`filter_var(..., FILTER_VALIDATE_EMAIL)`, password is at least 8
characters, the two password fields match, and the email isn't already
taken (checked with a `SELECT` before the `INSERT`, so a duplicate email
shows a friendly message instead of a raw database error from the
`UNIQUE` constraint on `users.email`).

Registering logs you in immediately - there's no separate "verify your
email" step in this project, so there's no reason to make a new user go
straight to a login form for an account they just created.

## Logging in

```php
if ($user && password_verify($password, $user['password'])) {
    $_SESSION['user_id'] = (int) $user['id'];
    session_regenerate_id(true);
    header('Location: index.php');
    exit;
}
$errors[] = 'Incorrect email or password.';
```

Notice the error message is identical whether the email doesn't exist
*or* the password is wrong. That's deliberate: showing a different
message for each ("no account with that email" vs. "wrong password")
would let an attacker use the login form to check which emails have
accounts at all, one guess at a time.

## Logging out

```php
$_SESSION = [];
session_destroy();
header('Location: index.php');
```

Two steps, not one: emptying the `$_SESSION` array clears the data;
`session_destroy()` removes the session itself from the server, so the
old session id in the browser's cookie can never be reused to log back
in even if someone got hold of it.
