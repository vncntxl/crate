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
standard PHP host that provides MySQL/MariaDB. It needs PHP 7.4 or
newer and makes no outbound network requests at runtime.

The steps below are written for InfinityFree, but the shape is the same
on any shared host.

1. **Create the hosting account.** Sign up at infinityfree.com, create a
   site, and pick a free subdomain. Wait for the account to finish
   activating before continuing.

2. **Create the database.** In the control panel, open **MySQL
   Databases** and create one. The panel then shows four values you need:
   the database name, username, password, and the **MySQL hostname**
   (something like `sql123.infinityfree.com`). Note all four.

3. **Import the schema.** Open phpMyAdmin from the control panel, select
   the new database, go to **Import**, choose `seed/crate.sql`, and run
   it. The file creates the four tables and their seed data. It does not
   contain a `CREATE DATABASE` statement, so it imports into whichever
   database you have selected.

4. **Point the app at that database.** Edit
   [includes/config.php](includes/config.php) and replace the four
   constants with the values from step 2:

   ```php
   define('DB_HOST', 'sql123.infinityfree.com');  // NOT localhost
   define('DB_NAME', 'if0_00000000_crate');
   define('DB_USER', 'if0_00000000');
   define('DB_PASS', 'your-database-password');
   ```

   `DB_HOST` is the most common thing to get wrong. On shared hosting the
   database usually lives on a separate server, so `localhost` will not
   connect.

5. **Upload the files.** Connect over FTP (FileZilla works) using the FTP
   details from the control panel, and upload the project **into the
   `htdocs/` folder**, not the account root. Files placed outside
   `htdocs/` are not served.

   Skip `.git/` and `report/` when uploading. Make sure
   `assets/covers/` and its JPEGs come across, or every album will fall
   back to a plain gradient.

6. **Test the live site.** Visit the domain and check, in order: the home
   page grid loads with cover art, search and a genre chip both filter,
   registering a new account works, submitting a review works, and the
   heart button adds to favourites. If the home page renders but stays
   empty, the database credentials in step 4 are wrong.

`seed/fetch_covers.php` is safe to upload. It refuses to run from a
browser and only works from a command line.
