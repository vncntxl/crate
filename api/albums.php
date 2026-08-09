<?php
// Crate - albums API
// Supports optional ?q= search and ?genre= filter.

require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

$q     = trim($_GET['q'] ?? '');
$genre = trim($_GET['genre'] ?? '');

try {
    if ($q !== '') {
        $stmt = db()->prepare(
            'SELECT * FROM albums
             WHERE title LIKE :q1 OR artist LIKE :q2
             ORDER BY title'
        );
        $stmt->execute([
            'q1' => '%' . $q . '%',
            'q2' => '%' . $q . '%',
        ]);

    } elseif ($genre !== '') {
        $stmt = db()->prepare('SELECT * FROM albums WHERE genre = :g ORDER BY title');
        $stmt->execute(['g' => $genre]);

    } else {
        $stmt = db()->query('SELECT * FROM albums ORDER BY RAND() LIMIT 8');
    }

    echo json_encode($stmt->fetchAll());

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not load albums.']);
}