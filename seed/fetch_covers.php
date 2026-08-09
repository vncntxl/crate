<?php
// Crate - one-off seeding script: real albums + real cover art
//
// Run this ONCE from the command line to fill the albums table:
//     php seed/fetch_covers.php
//
// It looks each album up in Apple's free iTunes Search API (no account or
// API key needed), takes the title, artist, release year, track count and
// cover artwork from the response, downloads the artwork into
// assets/covers/, and inserts the row.
//
// The live website never runs this file. By the time anyone visits the
// site, the covers are already sitting in assets/covers/ as ordinary
// image files and the paths are already in the database - so the site
// never depends on Apple's servers being reachable.

require_once __DIR__ . '/../includes/db.php';

// Only ever run from the command line. If this file somehow ends up on a
// live server, visiting it in a browser does nothing.
if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("This is a setup script. Run it from the command line.\n");
}

// The albums to seed.
//
// `search`  - what gets sent to the iTunes API.
// `expect`  - the exact album title we actually want. The API ranks
//             singles, EPs, remix packs and re-recordings above the real
//             album surprisingly often (searching "Taylor Swift 1989"
//             returns the Taylor's Version deluxe edition first), so we
//             ask for a page of results and pick the one whose title and
//             artist actually match instead of trusting the first hit.
// The rest is information the API doesn't return: the genre wording we
// want for the filter chips, label, producer, runtime, and our own
// description text.
$albums = [
    [
        'search'       => 'Fleetwood Mac Rumours',
        'expect'       => 'Rumours',
        'artist'       => 'Fleetwood Mac',
        'genre'        => 'Rock',
        'label'        => 'Warner Bros.',
        'producer'     => 'Fleetwood Mac, Ken Caillat, Richard Dashut',
        'duration_min' => 40,
        'description'  => 'Five band members writing through the collapse of their own relationships, and somehow turning it into the most polished pop-rock record of the decade.',
    ],
    [
        'search'       => 'Radiohead OK Computer',
        'expect'       => 'OK Computer',
        'artist'       => 'Radiohead',
        'genre'        => 'Rock',
        'label'        => 'Parlophone',
        'producer'     => 'Nigel Godrich, Radiohead',
        'duration_min' => 53,
        'description'  => 'Guitar music bent into something colder and stranger, full of dread about technology that only reads as more accurate with time.',
    ],
    [
        'search'       => 'Daft Punk Random Access Memories',
        'expect'       => 'Random Access Memories',
        'artist'       => 'Daft Punk',
        'genre'        => 'Electronic',
        'label'        => 'Columbia',
        'producer'     => 'Daft Punk',
        'duration_min' => 74,
        'description'  => 'Two robots hire live session players and disco veterans, then build an album about missing the way records used to sound.',
    ],
    [
        'search'       => 'Daft Punk Discovery',
        'expect'       => 'Discovery',
        'artist'       => 'Daft Punk',
        'genre'        => 'Electronic',
        'label'        => 'Virgin',
        'producer'     => 'Daft Punk',
        'duration_min' => 61,
        'description'  => 'Filtered house built out of chopped-up samples and pure nostalgia, and the record that taught a generation what a French touch drop sounds like.',
    ],
    [
        'search'       => 'Kendrick Lamar To Pimp a Butterfly',
        'expect'       => 'To Pimp a Butterfly',
        'artist'       => 'Kendrick Lamar',
        'genre'        => 'Hip-Hop',
        'label'        => 'Top Dawg / Aftermath / Interscope',
        'producer'     => 'Sounwave, Terrace Martin, Flying Lotus and others',
        'duration_min' => 79,
        'description'  => 'Free jazz, funk and spoken word pulled into a dense record about fame, survivor guilt and Black identity in America.',
    ],
    [
        'search'       => 'Kendrick Lamar good kid maad city',
        'expect'       => 'good kid, m.A.A.d city',
        'artist'       => 'Kendrick Lamar',
        'genre'        => 'Hip-Hop',
        'label'        => 'Top Dawg / Aftermath / Interscope',
        'producer'     => 'Dr. Dre, Sounwave, Hit-Boy and others',
        'duration_min' => 68,
        'description'  => 'A short film in album form: one day in Compton, told out of order, with the skits doing as much narrative work as the verses.',
    ],
    [
        'search'       => 'Miles Davis Kind of Blue',
        'expect'       => 'Kind of Blue',
        'artist'       => 'Miles Davis',
        'genre'        => 'Jazz',
        'label'        => 'Columbia',
        'producer'     => 'Irving Townsend, Teo Macero',
        'duration_min' => 45,
        'description'  => 'Recorded in two sessions with sketches instead of full charts, letting the band improvise around modes rather than chord changes.',
    ],
    [
        'search'       => 'John Coltrane A Love Supreme',
        'expect'       => 'A Love Supreme',
        'artist'       => 'John Coltrane',
        'genre'        => 'Jazz',
        'label'        => 'Impulse!',
        'producer'     => 'Bob Thiele',
        'duration_min' => 33,
        'description'  => 'A four-part suite written as a devotional offering, moving from restless searching into something close to peace.',
    ],
    [
        'search'       => 'Joni Mitchell Blue',
        'expect'       => 'Blue',
        'artist'       => 'Joni Mitchell',
        'genre'        => 'Folk',
        'label'        => 'Reprise',
        'producer'     => 'Henry Lewy',
        'duration_min' => 36,
        'description'  => 'Ten songs with almost nothing to hide behind, mostly voice against dulcimer, piano or open-tuned guitar.',
    ],
    [
        'search'       => 'Neil Young Harvest',
        'expect'       => 'Harvest',
        'artist'       => 'Neil Young',
        'genre'        => 'Folk',
        'label'        => 'Reprise',
        'producer'     => 'Elliot Mazer, Neil Young, Jack Nitzsche, Henry Lewy',
        'duration_min' => 37,
        'description'  => 'Country-leaning songs cut between Nashville, a barn in California and a London orchestra session, and the record that made him far bigger than he wanted to be.',
    ],
    [
        'search'       => 'Lorde Melodrama',
        'expect'       => 'Melodrama',
        'artist'       => 'Lorde',
        'genre'        => 'Indie Pop',
        'label'        => 'Lava / Republic',
        'producer'     => 'Jack Antonoff, Lorde',
        'duration_min' => 41,
        'description'  => 'One house party stretched across a whole album, running from the high of the first drink to the walk home alone.',
    ],
    [
        'search'       => 'Vampire Weekend Modern Vampires of the City',
        'expect'       => 'Modern Vampires of the City',
        'artist'       => 'Vampire Weekend',
        'genre'        => 'Indie Pop',
        'label'        => 'XL Recordings',
        'producer'     => 'Rostam Batmanglij, Ariel Rechtshaid',
        'duration_min' => 43,
        'description'  => 'The band drop the bright preppy guitars for pitch-shifted vocals and organ, and spend the album arguing with the idea of getting older.',
    ],
    [
        'search'       => 'Michael Jackson Thriller',
        'expect'       => 'Thriller',
        'artist'       => 'Michael Jackson',
        'genre'        => 'Pop',
        'label'        => 'Epic',
        'producer'     => 'Quincy Jones, Michael Jackson',
        'duration_min' => 42,
        'description'  => 'Pop, funk, rock and disco welded together with studio precision, and still the yardstick every big commercial record gets measured against.',
    ],
    [
        'search'       => 'Taylor Swift 1989',
        'expect'       => '1989',
        'artist'       => 'Taylor Swift',
        'genre'        => 'Pop',
        'label'        => 'Big Machine',
        'producer'     => 'Max Martin, Shellback, Jack Antonoff, Taylor Swift',
        'duration_min' => 49,
        'description'  => 'A full move from country into synth-pop, built on 80s drum sounds and hooks aimed squarely at radio.',
    ],
];

// Fallback gradient colours, kept so an album still looks like something
// if its artwork ever fails to download.
$palette = [
    ['#ff6b6b', '#ff9f7f'],
    ['#4d7dff', '#7fb2ff'],
    ['#1fbf9f', '#5fe0c4'],
    ['#8f5bff', '#b98bff'],
    ['#f2b90a', '#ffe07f'],
];

$coversDir = __DIR__ . '/../assets/covers';
if (!is_dir($coversDir)) {
    mkdir($coversDir, 0777, true);
}

// Start from a clean slate. The reviews and collection tables have
// ON DELETE CASCADE on album_id, so their rows go with the albums.
echo "Clearing existing albums...\n";
db()->exec('DELETE FROM albums');
db()->exec('ALTER TABLE albums AUTO_INCREMENT = 1');

$insert = db()->prepare(
    'INSERT INTO albums
        (title, artist, year, genre, label, producer, track_count, duration_min, description, cover_url, cover_color_1, cover_color_2)
     VALUES
        (:title, :artist, :year, :genre, :label, :producer, :track_count, :duration_min, :description, :cover_url, :c1, :c2)'
);

// Flattens a title for comparison: lowercase, punctuation stripped,
// spaces collapsed. This is what lets "good kid, m.A.A.d city" match the
// API's own spelling of the same album without worrying about commas or
// full stops.
function normalise_title(string $value): string
{
    $value = strtolower($value);
    $value = preg_replace('/[^a-z0-9 ]/', '', $value);
    return trim(preg_replace('/\s+/', ' ', $value));
}

foreach ($albums as $index => $album) {
    $query = http_build_query([
        'term'   => $album['search'],
        'entity' => 'album',
        'limit'  => 20,
    ]);

    $json = @file_get_contents('https://itunes.apple.com/search?' . $query);
    $data = $json ? json_decode($json, true) : null;
    $results = $data['results'] ?? [];

    // Pick the result whose title AND artist both match what we asked
    // for, rather than whatever the API happened to rank first.
    $result = null;
    $wantTitle = normalise_title($album['expect']);
    $wantArtist = normalise_title($album['artist']);

    foreach ($results as $candidate) {
        $gotTitle = normalise_title($candidate['collectionName'] ?? '');
        $gotArtist = normalise_title($candidate['artistName'] ?? '');

        if ($gotTitle === $wantTitle && $gotArtist === $wantArtist) {
            $result = $candidate;
            break;
        }
    }

    if (!$result) {
        echo "  SKIPPED (no exact match): {$album['artist']} - {$album['expect']}\n";
        continue;
    }

    // releaseDate comes back as an ISO timestamp like "2013-05-17T07:00:00Z",
    // so the first four characters are the year.
    $year = (int) substr($result['releaseDate'] ?? '0000', 0, 4);

    // artworkUrl100 is a 100x100 thumbnail. Swapping the size in the URL
    // is how you ask Apple's image server for a larger version.
    $artworkUrl = str_replace('100x100bb', '600x600bb', $result['artworkUrl100'] ?? '');

    $colors = $palette[$index % count($palette)];

    $insert->execute([
        'title'        => $result['collectionName'],
        'artist'       => $result['artistName'],
        'year'         => $year,
        'genre'        => $album['genre'],
        'label'        => $album['label'],
        'producer'     => $album['producer'],
        'track_count'  => (int) ($result['trackCount'] ?? 0),
        'duration_min' => $album['duration_min'],
        'description'  => $album['description'],
        'cover_url'    => null, // filled in below, once we know the new row's id
        'c1'           => $colors[0],
        'c2'           => $colors[1],
    ]);

    $albumId = (int) db()->lastInsertId();

    // Download the artwork and save it as assets/covers/{id}.jpg, so the
    // running site serves its own image files instead of hotlinking Apple.
    $imageData = $artworkUrl ? @file_get_contents($artworkUrl) : false;

    if ($imageData !== false) {
        file_put_contents($coversDir . '/' . $albumId . '.jpg', $imageData);

        db()->prepare('UPDATE albums SET cover_url = :url WHERE id = :id')
            ->execute(['url' => 'assets/covers/' . $albumId . '.jpg', 'id' => $albumId]);

        echo "  OK  {$result['artistName']} - {$result['collectionName']} ({$year})\n";
    } else {
        echo "  OK  {$result['artistName']} - {$result['collectionName']} ({$year}) [no artwork, using gradient]\n";
    }

    // Be polite to a free public API rather than hammering it.
    usleep(300000);
}

$total = db()->query('SELECT COUNT(*) FROM albums')->fetchColumn();
echo "\nDone. {$total} albums in the database.\n";
