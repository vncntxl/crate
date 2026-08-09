# Crate

A music album review web app built for **INT1059 Advanced Web** (Assessment 3).
Browse albums, search and filter by genre, leave star-rated reviews,
save favourites, and manage your own account.

**Live site:** _add your hosted URL here once deployed_
**Repository:** https://github.com/vncntxl/crate

## Tech stack

- HTML, CSS
- Vue.js 3, loaded via CDN. No build step, no npm.
- PHP, procedural style, PDO for database access
- MySQL / MariaDB

No frameworks, bundlers, or package managers. Every tool here is covered
directly in the unit (Modules 9-11) - see
[docs/01-big-picture.md](docs/01-big-picture.md) for why that matters.

## Features

- Home page showing 8 random albums
- Search by title or artist, and filter by genre (nav dropdown + chips)
- Album detail page: synopsis, metadata, average star rating, reviews
- User registration and login (hashed passwords, sessions)
- Star-rating review system: submit, edit, and delete your own reviews
- Favourites: add or remove from any album card or the detail page,
  manage them on a dedicated page
- Account page: update your name and email, change your password,
  manage your own reviews
- Admin-only page to add new albums, with server-side validation

## Setup (local, with XAMPP)

1. Copy this project into your XAMPP `htdocs` folder, e.g.
   `C:\xampp\htdocs\crate`.
2. Start **Apache** and **MySQL** in the XAMPP Control Panel.
3. Create the database and import the schema and seed data:
   - Open phpMyAdmin (`http://localhost/phpmyadmin`).
   - Create a new database named `crate`.
   - Import [seed/crate.sql](seed/crate.sql) into it (Import tab, choose file, Go).
4. Check [includes/config.php](includes/config.php) matches your MySQL
   setup. The defaults (`root` user, no password, host `localhost`) work
   for a stock XAMPP install with nothing changed.
5. Visit `http://localhost/crate/index.php` in your browser.

### Seed accounts

The imported data includes two demo users (see the `users` table), each
with existing reviews and one favourite already attached. To test as an
admin instead, register your own account, then promote it:

```sql
UPDATE users SET is_admin = 1 WHERE email = 'you@example.com';
```

The "Admin" link only appears in the nav bar for accounts with
`is_admin = 1`.

## Project structure

```
crate/
  index.php, album.php, login.php, register.php, ...   <- page shells
  includes/    config.php, db.php, auth.php, header.php, footer.php
  api/         JSON endpoints - see docs/ for what each one does
  js/          one Vue app per page
  css/         style.css - the whole site's styling
  assets/covers/  album artwork (JPEGs)
  seed/        crate.sql (full schema + seed data), fetch_covers.php
  docs/        write-up of every feature and concept, for the viva
```

## Cover art

Album artwork lives in `assets/covers/` as ordinary JPEG files, with
each path stored in `albums.cover_url`. Those files were fetched once by
`seed/fetch_covers.php`, which looks each album up in Apple's free
iTunes Search API and downloads the artwork. **The live site never runs
that script** and has no dependency on the API. It only reads the image
files already on disk.

You only need to re-run it if you want to rebuild the album table from
scratch:

```
php seed/fetch_covers.php
```

That command wipes and re-seeds the `albums` table, so it also clears
existing reviews and favourites through their `ON DELETE CASCADE`
foreign keys. It refuses to run from a browser.

## Documentation

[docs/README.md](docs/README.md) walks through the entire codebase: the
architecture, how Vue and PHP talk to each other, every security concept
in use (prepared statements, password hashing, sessions, ownership
checks), and a file-by-file explanation of each feature.

## Database

`seed/crate.sql` is a full export (schema and data) of the `crate`
database, produced with `mysqldump`. It has four tables: `users`,
`albums`, `reviews`, and `collection`, which is the favourites table -
see [docs/09-favourites.md](docs/09-favourites.md) for why the table
name and the feature name differ.

## Deployment

This app is plain PHP and MySQL with no build step, so it runs on any
standard PHP host that provides MySQL/MariaDB (shared hosting,
InfinityFree, 000webhost, and similar). To deploy:

1. Upload all files to the host.
2. Create a MySQL database on the host and import `seed/crate.sql`.
3. Update `includes/config.php` with the host's database credentials.
