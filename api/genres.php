<?php
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

try {
    $stmt = db()->query('SELECT DISTINCT genre FROM albums ORDER BY genre');
    echo json_encode($stmt->fetchAll(PDO::FETCH_COLUMN));

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not load genres.']);
}