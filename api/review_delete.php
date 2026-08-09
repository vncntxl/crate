<?php
// Crate - delete a review
// Only the review's own author can delete it. Used from the album page
// and from the account page's "manage your reviews" list.

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

$reviewId = (int) ($_POST['id'] ?? 0);
$userId = (int) $_SESSION['user_id'];

try {
    // The ownership check lives right in the WHERE clause: this can only
    // ever delete a row that both matches this id AND belongs to whoever
    // is currently logged in. If someone sends another user's review id,
    // this matches zero rows instead of deleting a review they don't own.
    $stmt = db()->prepare('DELETE FROM reviews WHERE id = :id AND user_id = :user_id');
    $stmt->execute(['id' => $reviewId, 'user_id' => $userId]);

    if ($stmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode(['error' => 'Review not found.']);
        exit;
    }

    echo json_encode(['success' => true]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not delete review.']);
}
