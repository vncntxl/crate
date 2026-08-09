<?php
require_once __DIR__ . '/includes/db.php';
$stmt = db()->query('SELECT * FROM albums ORDER BY title');
$albums = $stmt->fetchAll();

echo '<h1>Connection works</h1>';
echo '<p>Found ' . count($albums) . ' albums.</p>';
echo '<ul>';
foreach ($albums as $album) {
    echo '<li>' . htmlspecialchars($album['title'])
       . ' - ' . htmlspecialchars($album['artist']) . '</li>';
}
echo '</ul>';