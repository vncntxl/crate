# The Big Picture

## What Crate is

Crate is a website where people can browse music albums, search and
filter them, leave star-rated reviews, save favourites, and manage their
own account. It's built for INT1059 Advanced Web using only the tools
the unit actually teaches: HTML, CSS, PHP, MySQL, and Vue 3.

## The one idea that explains almost everything

**PHP returns JSON. Vue renders it.**

Think of it like a restaurant:

- **MySQL** is the pantry — it just stores ingredients (rows of data).
- **PHP files in `api/`** are the kitchen and the waiter combined. They
  fetch the right ingredients from the pantry (a SQL query), plate them
  up in a standard format (JSON — just plain text that looks like
  `{"title": "Golden Static", "year": 2023}`), and hand the plate to your
  table. They never decorate the table or hand you a menu written in
  HTML — they only ever hand over the food itself, as data.
- **Vue**, running in your browser, is you at the table. It looks at
  what's on the plate (the JSON) and decides how to arrange it on the
  page — a grid of album cards, a row of stars, a list of reviews. If you
  ask for something different (type in the search box), Vue asks the
  kitchen again and re-arranges the table without you needing to get up
  and sit at a new table (no page reload).
- **Page files** like `index.php` and `album.php` are just the empty
  table itself — a `<div id="app">` — plus a page title and the shared
  nav bar. They do almost no work themselves.

This split matters for the viva: if someone asks "why is this a good
design?", the answer is that the **back end (PHP/MySQL) and front end
(Vue) don't need to know much about each other**. PHP doesn't care how
the JSON gets displayed, and Vue doesn't care how the JSON was produced.
You could swap out Vue for a totally different front end and the `api/`
files wouldn't need to change at all.

## Two exceptions, and why

**Login, register, and logout are NOT done through `fetch()`/JSON.**
They're plain, old-fashioned HTML `<form method="post">` pages. This is
deliberate: authentication only needs to happen once per action (submit
the form, get redirected), there's no benefit to making it "reactive",
and keeping it as a simple, linear PHP script makes the
security-critical code (checking passwords, starting sessions) easier to
read top-to-bottom — nothing is hidden behind an asynchronous JavaScript
call.

**The genre dropdown in the nav bar is rendered by PHP, not Vue.** It
only needs to read the list of genres once, when the page first loads —
that's a job the server can do directly (see `includes/header.php`)
without needing any JavaScript at all.

## Folder structure

```
crate/
  index.php, album.php, login.php, register.php, ...   <- page shells
  includes/
    config.php   <- database connection settings (host, name, password)
    db.php       <- the one function, db(), that connects to MySQL
    auth.php     <- session helpers: is_logged_in(), current_user(), etc.
    header.php   <- shared <head> + nav bar, included at the top of every page
    footer.php   <- shared closing tags + footer, included at the bottom
  api/
    albums.php, album.php, review_add.php, ...          <- JSON endpoints
  js/
    app.js, album.js, account.js, ...                   <- one Vue app per page
  css/
    style.css                                            <- the whole site's styling
  seed/            <- one-off scripts used to set up demo data
  assets/covers/    <- (currently unused - see docs/12-styling.md)
```

Every page follows the same three-line skeleton:

```php
require_once __DIR__ . '/includes/auth.php';   // 1. know who's logged in
$pageTitle = SITE_NAME . ' - Home';             // 2. set the <title>
require_once __DIR__ . '/includes/header.php';  // 3. print the shared top half
```
...page-specific HTML and a `<div id="app">`...
```php
require_once __DIR__ . '/includes/footer.php';  // print the shared bottom half
```

## Why this stack and nothing else

No Laravel, no React, no npm, no build step, no Composer. That's not a
limitation we worked around — it's the actual assignment constraint: the
unit's modules only cover procedural PHP + PDO (Module 10) and Vue 3
(Modules 9 and 11). Every tool used here is one you can point to in the
subject outline, which means every choice is defensible in the viva.
