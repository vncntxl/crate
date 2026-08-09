<?php
// Crate - single album API
// Given ?id=, returns that album's details, its reviews (newest first,
// with the reviewer's name joined in), and the average rating.

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

$id = (int) ($_GET['id'] ?? 0);

if ($id <= 0) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing or invalid album id.']);
    exit;
}

try {
    $albumStmt = db()->prepare('SELECT * FROM albums WHERE id = :id');
    $albumStmt->execute(['id' => $id]);
    $album = $albumStmt->fetch();

    if (!$album) {
        http_response_code(404);
        echo json_encode(['error' => 'Album not found.']);
        exit;
    }

    // JOIN pulls in the reviewer's name from the users table, so the
    // front end doesn't need a second request just to know who wrote
    // each review.
    $reviewStmt = db()->prepare(
        'SELECT reviews.id, reviews.user_id, reviews.rating, reviews.review_text, reviews.created_at,
                users.name AS user_name
         FROM reviews
         JOIN users ON users.id = reviews.user_id
         WHERE reviews.album_id = :id
         ORDER BY reviews.created_at DESC'
    );
    $reviewStmt->execute(['id' => $id]);
    $reviews = $reviewStmt->fetchAll();

    $statsStmt = db()->prepare(
        'SELECT AVG(rating) AS average_rating, COUNT(*) AS review_count
         FROM reviews
         WHERE album_id = :id'
    );
    $statsStmt->execute(['id' => $id]);
    $stats = $statsStmt->fetch();

    // If someone is logged in, also tell the front end whether they've
    // already reviewed this album (and what they said), so album.php can
    // show "edit your review" instead of a second, duplicate review form.
    $myReview = null;
    $isFavourited = false;
    if (is_logged_in()) {
        $myReviewStmt = db()->prepare(
            'SELECT id, rating, review_text FROM reviews WHERE album_id = :album_id AND user_id = :user_id'
        );
        $myReviewStmt->execute(['album_id' => $id, 'user_id' => $_SESSION['user_id']]);
        $myReview = $myReviewStmt->fetch() ?: null;

        $favStmt = db()->prepare(
            'SELECT id FROM collection WHERE album_id = :album_id AND user_id = :user_id'
        );
        $favStmt->execute(['album_id' => $id, 'user_id' => $_SESSION['user_id']]);
        $isFavourited = (bool) $favStmt->fetch();
    }

    echo json_encode([
        'album'          => $album,
        'reviews'        => $reviews,
        'average_rating' => $stats['average_rating'] !== null ? round((float) $stats['average_rating'], 1) : null,
        'review_count'   => (int) $stats['review_count'],
        'my_review'      => $myReview,
        'is_favourited'  => $isFavourited,
    ]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not load album.']);
}
