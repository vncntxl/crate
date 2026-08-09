<?php
// Crate - authentication helpers
// Every page that needs to know "who is logged in" includes this file first.
// It wraps PHP's built-in session system so we don't repeat the same
// session_start() / $_SESSION checks in every single page.

require_once __DIR__ . '/config.php';

// Starts (or resumes) the session. This must run before any HTML is sent,
// which is why every page includes this file at the very top.
session_start();

// True if the browser's session has a user_id stored in it.
// We only ever store the id (a number), never the whole user row, in the
// session - if we need more details we look them up fresh from the database.
function is_logged_in(): bool
{
    return isset($_SESSION['user_id']);
}

// Returns the full row (id, name, email, is_admin) for whoever is logged in,
// or null if nobody is. Cached in a static variable so calling this multiple
// times on the same page only hits the database once.
function current_user(): ?array
{
    if (!is_logged_in()) {
        return null;
    }

    static $cachedUser = null;

    if ($cachedUser === null) {
        require_once __DIR__ . '/db.php';

        $stmt = db()->prepare('SELECT id, name, email, is_admin FROM users WHERE id = :id');
        $stmt->execute(['id' => $_SESSION['user_id']]);
        $cachedUser = $stmt->fetch() ?: false;
    }

    return $cachedUser ?: null;
}

// Call this at the top of any page that must be logged-in-only
// (e.g. account.php). If nobody is logged in, it redirects to the login
// page and stops the rest of the page from running.
function require_login(): void
{
    if (!is_logged_in()) {
        header('Location: login.php');
        exit;
    }
}

// Call this at the top of any page only admins may see (e.g. admin.php).
function require_admin(): void
{
    require_login();

    $user = current_user();
    if (!$user || !$user['is_admin']) {
        http_response_code(403);
        exit('Admins only.');
    }
}

// Short for "escape". Wraps htmlspecialchars() so that whenever we print
// something a user typed (a name, an email, review text) back into HTML,
// the browser displays it as plain text instead of running it as HTML/JS.
// This is what stops a review like "<script>...</script>" from executing.
function e(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}
