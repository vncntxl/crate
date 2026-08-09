<?php
// Crate - add or update a review
// A logged-in user submits a star rating (and optional text) for an
// album. If they've already reviewed this album, this updates that
// review instead of creating a second one - the unique_user_album index
// added to the reviews table backs this up as a hard database rule, not
// just something we hope the PHP code gets right.

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

// Every write endpoint checks login before doing anything else. Without
// this, anyone could call this URL directly (with curl, Postman, etc.)
// and post a review while pretending to be logged in.
if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['error' => 'You must be logged in to leave a review.']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed.']);
    exit;
}

$albumId = (int) ($_POST['album_id'] ?? 0);
$rating = (int) ($_POST['rating'] ?? 0);
$reviewText = trim($_POST['review_text'] ?? '');

// Server-side validation. Vue's star-picker component only lets the user
// click stars 1-5 in the first place, but that's a convenience for
// honest users, not a security boundary - anyone can send any value
// straight to this file, so we check the real rule again here.
if ($albumId <= 0 || $rating < 1 || $rating > 5) {
    http_response_code(422);
    echo json_encode(['error' => 'A star rating between 1 and 5 is required.']);
    exit;
}

$userId = (int) $_SESSION['user_id'];

try {
    $albumStmt = db()->prepare('SELECT id FROM albums WHERE id = :id');
    $albumStmt->execute(['id' => $albumId]);
    if (!$albumStmt->fetch()) {
        http_response_code(404);
        echo json_encode(['error' => 'Album not found.']);
        exit;
    }

    $existingStmt = db()->prepare('SELECT id FROM reviews WHERE user_id = :user_id AND album_id = :album_id');
    $existingStmt->execute(['user_id' => $userId, 'album_id' => $albumId]);
    $existing = $existingStmt->fetch();

    if ($existing) {
        // Ownership check: even though we already found this row using
        // the session's own user_id, we repeat that condition in the
        // UPDATE's WHERE clause itself, so this statement can only ever
        // change a row this session actually owns.
        $updateStmt = db()->prepare(
            'UPDATE reviews SET rating = :rating, review_text = :text
             WHERE id = :id AND user_id = :user_id'
        );
        $updateStmt->execute([
            'rating'  => $rating,
            'text'    => $reviewText !== '' ? $reviewText : null,
            'id'      => $existing['id'],
            'user_id' => $userId,
        ]);
    } else {
        $insertStmt = db()->prepare(
            'INSERT INTO reviews (user_id, album_id, rating, review_text)
             VALUES (:user_id, :album_id, :rating, :text)'
        );
        $insertStmt->execute([
            'user_id'  => $userId,
            'album_id' => $albumId,
            'rating'   => $rating,
            'text'     => $reviewText !== '' ? $reviewText : null,
        ]);
    }

    echo json_encode(['success' => true]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not save review.']);
}
