# Crate

A music album review web app built for **INT1059 Advanced Web** (Assessment 3).
Browse albums, search and filter by genre, leave star-rated reviews,
save favourites, and manage your own account.

**Live site:** _add your hosted URL here once deployed_
**Repository:** https://github.com/vncntxl/crate

## Tech stack

- HTML, CSS
- Vue.js 3 (loaded via CDN — no build step, no npm)
- PHP (procedural, PDO for database access)
- MySQL / MariaDB

No frameworks, bundlers, or package managers — everything here is a tool
covered directly in the unit (Modules 9–11). See
[docs/01-big-picture.md](docs/01-big-picture.md) for why.

## Features

- Home page showing 8 random albums
- Search by title or artist, and filter by genre (nav dropdown + chips)
- Album detail page: synopsis, metadata, average star rating, reviews
- User registration and login (hashed passwords, sessions)
- Star-rating review system — submit, edit, and delete your own reviews
- Favourites: add/remove from any album card or the detail page, manage
  them on a dedicated page
- Account page: update your name/email, change your password, manage
  your own reviews
- Admin-only page to add new albums (with server-side validation)

## Setup (local, with XAMPP)

1. Copy this project into your XAMPP `htdocs` folder, e.g.
   `C:\xampp\htdocs\crate`.
2. Start **Apache** and **MySQL** in the XAMPP Control Panel.
3. Create the database and import the schema + seed data:
   - Open phpMyAdmin (`http://localhost/phpmyadmin`).
   - Create a new database named `crate`.
   - Import [seed/crate.sql](seed/crate.sql) into it (Import tab → choose file → Go).
4. Check [includes/config.php](includes/config.php) matches your MySQL
   setup. The defaults (`root` user, no password, host `localhost`) work
   for a stock XAMPP install with nothing changed.
5. Visit `http://localhost/crate/index.php` in your browser.

### Seed accounts

The imported data includes two demo users (see `users` table) with
existing reviews and a favourite already attached. If you'd rather
register your own account and test as an admin, register normally, then
promote yourself with:

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
  seed/        crate.sql (full schema + seed data)
  docs/        beginner-friendly write-up of every feature and concept
```

## Documentation

[docs/README.md](docs/README.md) is a full, plain-language walkthrough
of the entire codebase — architecture, how Vue and PHP talk to each
other, every security concept used (prepared statements, password
hashing, sessions, ownership checks), and a file-by-file explanation of
every feature.

## Database

`seed/crate.sql` is a full export (schema + data) of the `crate`
database, produced with `mysqldump`. It includes four tables: `users`,
`albums`, `reviews`, `collection` (the favourites table — see
[docs/09-favourites.md](docs/09-favourites.md) for why the table name
and the feature name differ).

## Deployment

This app is plain PHP + MySQL with no build step, so it will run on any
standard PHP hosting that provides MySQL/MariaDB (shared hosting,
InfinityFree, 000webhost, etc.). To deploy:

1. Upload all files to the host.
2. Create a MySQL database on the host and import `seed/crate.sql`.
3. Update `includes/config.php` with the host's database credentials.
