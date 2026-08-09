<?php
// Crate - list the logged-in user's favourited albums
// Used by the "Your Favourites" page, and by the home page to know which
// hearts should already be filled in.

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['error' => 'You must be logged in.']);
    exit;
}

try {
    // JOIN collection to albums, filtered to this session's user_id only -
    // nobody can ever see another user's favourites through this endpoint.
    $stmt = db()->prepare(
        'SELECT albums.* FROM albums
         JOIN collection ON collection.album_id = albums.id
         WHERE collection.user_id = :user_id
         ORDER BY collection.created_at DESC'
    );
    $stmt->execute(['user_id' => $_SESSION['user_id']]);
    echo json_encode($stmt->fetchAll());

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not load favourites.']);
}
