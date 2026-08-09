<?php
// Crate - shared page header
// This is the "top half" every page has in common: the <head> tag and the
// navigation bar. Each page sets $pageTitle before including this file,
// e.g.  $pageTitle = 'Crate - Home';
// Putting this in one file means if we want to change the nav bar, we
// change it here once instead of in every page.

require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/db.php';

$loggedInUser = current_user();

// The genre dropdown is plain PHP + a database query, not Vue. It appears
// on every page (it lives in this shared header), and it only needs to
// read data once when the page loads - that's a job for the server, not
// for client-side JavaScript.
$navGenres = db()->query('SELECT DISTINCT genre FROM albums ORDER BY genre')->fetchAll(PDO::FETCH_COLUMN);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= e($pageTitle ?? SITE_NAME) ?></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header class="site-nav">
    <a href="index.php" class="brand"><?= e(SITE_NAME) ?></a>

    <nav>
        <a href="index.php">Home</a>

        <div class="dropdown">
            <button type="button" class="dropdown-toggle">Genres</button>
            <div class="dropdown-menu" id="genre-dropdown">
                <?php foreach ($navGenres as $navGenre): ?>
                    <a href="index.php?genre=<?= urlencode($navGenre) ?>"><?= e($navGenre) ?></a>
                <?php endforeach; ?>
            </div>
        </div>

        <?php if ($loggedInUser): ?>
            <a href="collection.php">Favourites</a>
            <a href="account.php">Account</a>
            <?php if ($loggedInUser['is_admin']): ?>
                <a href="admin.php">Admin</a>
            <?php endif; ?>
            <span class="nav-user">Hi, <?= e($loggedInUser['name']) ?></span>
            <a href="logout.php">Logout</a>
        <?php else: ?>
            <a href="login.php">Login</a>
            <a href="register.php">Register</a>
        <?php endif; ?>
    </nav>
</header>

<main>
