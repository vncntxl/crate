<?php
// Crate - logout
// No page to look at here - this file just ends the session and bounces
// the browser back to the homepage.

require_once __DIR__ . '/includes/auth.php';

// Empty out the session array...
$_SESSION = [];

// ...then destroy the session itself on the server so the old session id
// can never be reused.
session_destroy();

header('Location: index.php');
exit;
