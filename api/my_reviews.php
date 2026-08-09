<?php
// Crate - list the logged-in user's own reviews
// Used by the account page's "manage your reviews" section. Joins in the
// album's title/artist so the page can show something readable instead
// of just an album_id number.

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['error' => 'You must be logged in.']);
    exit;
}

try {
    // Filtered to WHERE reviews.user_id = the session's own id - this
    // endpoint can only ever return the logged-in user's own reviews,
    // never anyone else's.
    $stmt = db()->prepare(
        'SELECT reviews.id, reviews.album_id, reviews.rating, reviews.review_text, reviews.created_at,
                albums.title AS album_title, albums.artist AS album_artist
         FROM reviews
         JOIN albums ON albums.id = reviews.album_id
         WHERE reviews.user_id = :user_id
         ORDER BY reviews.created_at DESC'
    );
    $stmt->execute(['user_id' => $_SESSION['user_id']]);
    echo json_encode($stmt->fetchAll());

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not load your reviews.']);
}
