<?php
// Crate - update the logged-in user's name and email

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

$name = trim($_POST['name'] ?? '');
$email = trim($_POST['email'] ?? '');
$userId = (int) $_SESSION['user_id'];

if ($name === '') {
    http_response_code(422);
    echo json_encode(['error' => 'Please enter your name.']);
    exit;
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(422);
    echo json_encode(['error' => 'Please enter a valid email address.']);
    exit;
}

try {
    // Someone else might already have this email - the database's UNIQUE
    // constraint on users.email would stop the UPDATE anyway, but
    // checking first lets us return a friendly message instead of a raw
    // database error.
    $existsStmt = db()->prepare('SELECT id FROM users WHERE email = :email AND id != :id');
    $existsStmt->execute(['email' => $email, 'id' => $userId]);
    if ($existsStmt->fetch()) {
        http_response_code(422);
        echo json_encode(['error' => 'That email is already in use by another account.']);
        exit;
    }

    // WHERE id = :id, and :id is always the session's own user id - this
    // can only ever update the logged-in user's own row.
    $stmt = db()->prepare('UPDATE users SET name = :name, email = :email WHERE id = :id');
    $stmt->execute(['name' => $name, 'email' => $email, 'id' => $userId]);

    echo json_encode(['success' => true, 'name' => $name, 'email' => $email]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not update account.']);
}
