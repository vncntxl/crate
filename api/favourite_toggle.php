<?php
// Crate - add or remove an album from the logged-in user's favourites
// "Toggle" means one endpoint handles both directions: if the album is
// already favourited, this un-favourites it, and vice versa. The response
// tells the front end which state it ended up in.

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['error' => 'You must be logged in.']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed.']);
    exit;
}

$albumId = (int) ($_POST['album_id'] ?? 0);
$userId = (int) $_SESSION['user_id'];

if ($albumId <= 0) {
    http_response_code(422);
    echo json_encode(['error' => 'Missing album id.']);
    exit;
}

try {
    $existingStmt = db()->prepare('SELECT id FROM collection WHERE user_id = :user_id AND album_id = :album_id');
    $existingStmt->execute(['user_id' => $userId, 'album_id' => $albumId]);
    $existing = $existingStmt->fetch();

    if ($existing) {
        // Ownership check baked into the WHERE clause: this can only ever
        // remove a favourite row that belongs to the logged-in user.
        $deleteStmt = db()->prepare('DELETE FROM collection WHERE id = :id AND user_id = :user_id');
        $deleteStmt->execute(['id' => $existing['id'], 'user_id' => $userId]);
        echo json_encode(['favourited' => false]);
        exit;
    }

    $albumStmt = db()->prepare('SELECT id FROM albums WHERE id = :id');
    $albumStmt->execute(['id' => $albumId]);
    if (!$albumStmt->fetch()) {
        http_response_code(404);
        echo json_encode(['error' => 'Album not found.']);
        exit;
    }

    $insertStmt = db()->prepare('INSERT INTO collection (user_id, album_id) VALUES (:user_id, :album_id)');
    $insertStmt->execute(['user_id' => $userId, 'album_id' => $albumId]);
    echo json_encode(['favourited' => true]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not update favourites.']);
}
