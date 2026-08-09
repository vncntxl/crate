<?php
// Crate - add a new album (admin only)

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/db.php';

header('Content-Type: application/json; charset=utf-8');

if (!is_logged_in()) {
    http_response_code(401);
    echo json_encode(['error' => 'You must be logged in.']);
    exit;
}

// The admin check happens here, on the server - not just by hiding the
// "Admin" nav link for non-admins. Hiding a link is a UI nicety; this is
// the real security boundary. Even if a non-admin found this URL
// directly and posted to it with curl, this check still stops them.
$user = current_user();
if (!$user || !$user['is_admin']) {
    http_response_code(403);
    echo json_encode(['error' => 'Admins only.']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed.']);
    exit;
}

$title = trim($_POST['title'] ?? '');
$artist = trim($_POST['artist'] ?? '');
$year = (int) ($_POST['year'] ?? 0);
$genre = trim($_POST['genre'] ?? '');
$label = trim($_POST['label'] ?? '');
$producer = trim($_POST['producer'] ?? '');
$trackCount = ($_POST['track_count'] ?? '') !== '' ? (int) $_POST['track_count'] : null;
$durationMin = ($_POST['duration_min'] ?? '') !== '' ? (int) $_POST['duration_min'] : null;
$description = trim($_POST['description'] ?? '');

// Server-side validation. Vue's admin form checks these same rules
// before it even sends the request, but that check runs in the
// visitor's own browser, where it can be edited or skipped entirely -
// so the rule that actually counts is this one.
$errors = [];
if ($title === '') {
    $errors[] = 'Title is required.';
}
if ($artist === '') {
    $errors[] = 'Artist is required.';
}
if ($genre === '') {
    $errors[] = 'Genre is required.';
}
if ($year < 1900 || $year > (int) date('Y')) {
    $errors[] = 'Enter a valid year.';
}

if (!empty($errors)) {
    http_response_code(422);
    echo json_encode(['error' => implode(' ', $errors)]);
    exit;
}

// The albums table styles cards with a two-colour gradient instead of a
// real cover image (see cover_color_1/2). Give new albums a random one
// from the same palette the seed data uses.
$palette = [
    ['#ff6b6b', '#ff9f7f'],
    ['#4d7dff', '#7fb2ff'],
    ['#1fbf9f', '#5fe0c4'],
    ['#8f5bff', '#b98bff'],
    ['#f2b90a', '#ffe07f'],
];
$colors = $palette[array_rand($palette)];

try {
    $stmt = db()->prepare(
        'INSERT INTO albums (title, artist, year, genre, label, producer, track_count, duration_min, description, cover_color_1, cover_color_2)
         VALUES (:title, :artist, :year, :genre, :label, :producer, :track_count, :duration_min, :description, :c1, :c2)'
    );
    $stmt->execute([
        'title'        => $title,
        'artist'       => $artist,
        'year'         => $year,
        'genre'        => $genre,
        'label'        => $label !== '' ? $label : null,
        'producer'     => $producer !== '' ? $producer : null,
        'track_count'  => $trackCount,
        'duration_min' => $durationMin,
        'description'  => $description !== '' ? $description : null,
        'c1'           => $colors[0],
        'c2'           => $colors[1],
    ]);

    echo json_encode(['success' => true, 'id' => (int) db()->lastInsertId()]);

} catch (PDOException $err) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not add album.']);
}
