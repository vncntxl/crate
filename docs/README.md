# Crate: Code Explained (read this before the viva)

This folder explains every part of Crate in plain language, written so
you can read it once and then explain the code yourself without notes.
Each file covers one topic or one feature, in the order the app was
actually built.

Read them in this order:

1. [01-big-picture.md](01-big-picture.md): what Crate is and how the pieces fit together
2. [02-vue-basics.md](02-vue-basics.md): how Vue 3 works, loaded straight from a CDN
3. [03-php-and-database-basics.md](03-php-and-database-basics.md): PDO, prepared statements, sessions, hashing
4. [04-naming-conventions.md](04-naming-conventions.md): why things are named the way they are
5. [05-security-concepts.md](05-security-concepts.md): a cheat sheet of every security idea the viva might ask about
6. [06-homepage-and-search.md](06-homepage-and-search.md): the home page grid, search, genre filter
7. [07-album-detail-and-reviews.md](07-album-detail-and-reviews.md): album page, star ratings, writing a review
8. [08-authentication.md](08-authentication.md): register, login, logout, sessions
9. [09-favourites.md](09-favourites.md): the heart button and the favourites page
10. [10-account-page.md](10-account-page.md): editing your profile, password, and your reviews
11. [11-admin.md](11-admin.md): the admin-only "add an album" page
12. [12-styling.md](12-styling.md): the CSS approach, variables and responsive layout

For any line of code in the viva, you should be able to answer three
questions: what does this do, why does it exist, and what would break if
it weren't here. These docs answer all three for every file in the
project.
