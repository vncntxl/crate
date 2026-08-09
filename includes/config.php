<?php
// Crate - database configuration
//
// These are the LOCAL development settings (XAMPP: user "root", no
// password). They are safe to commit and safe to share.
//
// The live server needs different values, and a live database password
// must never end up in a public GitHub repository. So instead of editing
// this file for deployment, the live server gets a second file next to
// this one called config.local.php holding just its own settings:
//
//     <?php
//     define('DB_HOST', 'sqlXXX.infinityfree.com');
//     define('DB_NAME', 'if0_XXXXXXX_crate');
//     define('DB_USER', 'if0_XXXXXXX');
//     define('DB_PASS', 'the-real-password');
//
// config.local.php is listed in .gitignore, so it can never be committed
// by accident. If it exists it is loaded first, and because PHP keeps the
// FIRST value a constant is given, its settings win over the defaults
// below. Uploading a new copy of this file can no longer wipe out the
// server's credentials either.

if (file_exists(__DIR__ . '/config.local.php')) {
    require_once __DIR__ . '/config.local.php';
}

// defined() checks below mean "only set this if config.local.php hasn't
// already".
if (!defined('DB_HOST')) {
    define('DB_HOST', 'localhost');
}
if (!defined('DB_NAME')) {
    define('DB_NAME', 'crate');
}
if (!defined('DB_USER')) {
    define('DB_USER', 'root');
}
if (!defined('DB_PASS')) {
    define('DB_PASS', '');
}
if (!defined('SITE_NAME')) {
    define('SITE_NAME', 'Crate');
}
