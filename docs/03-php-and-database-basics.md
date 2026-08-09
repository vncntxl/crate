# PHP and Database Basics

## Procedural, not object-oriented

Crate's PHP is written **procedurally**: files with top-to-bottom
scripts and plain functions (`db()`, `is_logged_in()`, `e()`), not
classes and objects. This matches what the unit teaches (Module 10) and
keeps every file readable as "do this, then this, then this," which is
exactly the shape a viva answer needs to take too: first we check
they're logged in, then we validate the input, then we run the query.

## PDO and prepared statements

**PDO** (PHP Data Objects) is PHP's standard way of talking to a
database. `includes/db.php` has one function, `db()`, that opens a
connection the first time it's called and reuses that same connection
for the rest of the request:

```php
function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
    }
    return $pdo;
}
```

Every single query in this project uses a **prepared statement**:

```php
$stmt = db()->prepare('SELECT * FROM albums WHERE id = :id');
$stmt->execute(['id' => $id]);
```

Picture a form letter: *"Dear ___, you owe $___."* A prepared statement
sends the **shape** of the SQL query to the database first
(`WHERE id = :id`), with `:id` as a blank to fill in later. Only then
does it send the actual value. The database always treats that value as
**data to be compared**, never as a piece of the command itself. Type
`"; DROP TABLE users; --` into a search box and it gets searched for as
a literal, pointless string, not executed as SQL.

Compare that to gluing strings together by hand:

```php
// Never do this - shown only to explain the danger
$sql = "SELECT * FROM albums WHERE id = " . $_GET['id'];
```

Here, whatever the user typed becomes part of the actual command. This
is called **SQL injection**, the single most-asked-about security
concept in a database-backed viva. Every query in `api/*.php` either
uses a named placeholder (`:id`) or, for the one case with no user input
at all (`SELECT DISTINCT genre FROM albums`), a plain `->query()` with
no placeholders needed.

## Sessions: how the server remembers who you are

HTTP is stateless. The server forgets everything the moment it finishes
responding to one request. So how does the site remember you're logged
in from page to page? **Sessions.**

Picture a coat check ticket. When you log in (`login.php`), the server
generates a random ID, stores it in a cookie in your browser, and keeps
a matching note in its own memory: *"session abc123 belongs to user
7."* Every request your browser makes afterwards automatically includes
that cookie, so the server recognises you without asking you to log in
on every single page.

```php
session_start();               // resumes (or starts) the session
$_SESSION['user_id'] = 7;      // the ONLY thing we store in it
```

Crate stores the bare minimum in the session: just the numeric user id,
never the whole user record. Every time more is needed (their name,
their `is_admin` flag), `current_user()` in `includes/auth.php` looks it
up fresh from the database. That way, if an admin flag or email changes,
the very next page load sees the up-to-date value instead of a stale
copy sitting in the session.

`session_regenerate_id(true)` is called right after a successful login
or registration. This swaps in a brand new session ID at the exact
moment someone's logged-in status changes, which defends against
**session fixation**: a scenario where an attacker tricks a victim into
using a session ID the attacker already knows, then waits for the
victim to log in "as themselves" under that ID.

## Password hashing

```php
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);
```

Think of `password_hash()` like a blender. It turns a password into a
smoothie: a long, scrambled string, produced with the bcrypt algorithm.
You cannot un-blend a smoothie back into whole strawberries, and there
is no function that reverses a hash back into the original password.
That's the whole point. If the `users` table were ever leaked, an
attacker would only see the smoothie, not the password.

Logging in doesn't reverse the hash either. `password_verify()` blends
the password the user just typed using the same recipe and checks
whether the two smoothies match:

```php
if (password_verify($typedPassword, $storedHash)) {
    // correct password
}
```

## Escaping output: `e()`

```php
function e(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}
```

This is a short wrapper around PHP's built-in `htmlspecialchars()`,
named `e()` for "escape" so it stays fast to type. It's used everywhere
a user-typed value (a name, a review) gets printed back into the page,
e.g. `<?= e($loggedInUser['name']) ?>`.

Without it, someone could register with the name
`<script>alert('hi')</script>` and it would run as real HTML the moment
it was printed back onto a page: a **cross-site scripting (XSS)**
attack. `htmlspecialchars()` converts the dangerous characters (`<`,
`>`, `"`, `'`, `&`) into their harmless text equivalents (`&lt;`,
`&gt;`, and so on), so the browser displays them as plain text instead
of running them.
