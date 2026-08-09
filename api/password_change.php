<?php
// Crate - change the logged-in user's password

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

$currentPassword = $_POST['current_password'] ?? '';
$newPassword = $_POST['new_password'] ?? '';
$newPasswordConfirm = $_POST['new_password_confirm'] ?? '';
$userId = (int) $_SESSION['user_id'];

if (strlen($newPassword) < 8) {
    http_response_code(422);
    echo json_encode(['error' => 'New password must be at least 8 characters.']);
    exit;
}
if ($newPassword !== $newPasswordConfirm) {
    http_response_code(422);
    echo json_encode(['error' => 'New passwords do not match.']);
    exit;
}

try {
    $stmt = db()->prepare('SELECT password FROM users WHERE id = :id');
    $stmt->execute(['id' => $userId]);
    $user = $stmt->fetch();

    // Before allowing a password change, make the user prove they still
    // know the CURRENT password. Without this check, anyone who found an
    // already-logged-in browser (a shared computer, an unlocked laptop)
    // could lock the real owner out just by setting a new password.
    if (!$user || !password_verify($currentPassword, $user['password'])) {
        http_response_code(422);
        echo json_encode(['error' => 'Current password is incorrect.']);
        exit;
    }

    $newHash = password_hash($newPassword, PASSWORD_DEFAULT);
    $updateStmt = db()->prepare('UPDATE users SET password = :password WHERE id = :id');
    $updateStmt->execute(['password' => $newHash, 'id' => $userId]);

    echo json_encode(['success' => true]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not change password.']);
}
