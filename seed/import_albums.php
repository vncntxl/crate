<?php
// Crate - one-off seeding script: builds the whole album catalogue
//
// Run this ONCE from the command line:
//     php seed/import_albums.php
//
// For each artist below it asks Apple's free iTunes Search API (no
// account or API key needed) for that artist's albums, throws away the
// singles, EPs, live records and reissues, and keeps what's left. From
// the API response it fills in the title, artist, release year, genre,
// track count and record label, downloads the cover artwork into
// assets/covers/, and works out the album's running time by adding up
// the length of every track on it.
//
// The live website never runs this file. By the time anyone visits the
// site the covers are ordinary image files on disk and the metadata is
// already in the database, so nothing depends on Apple being reachable.

require_once __DIR__ . '/../includes/db.php';

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("This is a setup script. Run it from the command line.\n");
}

// Roughly how many albums to end up with. The artist list below can
// supply far more than this; we stop once we hit the target.
const TARGET_ALBUMS = 150;

// Most albums to take from any one artist. Without a cap the catalogue is
// decided by whoever has the longest discography: Bill Evans alone offers
// 83 qualifying albums and Miles Davis over 100, so a straight random
// pick came out as mostly deep-cut jazz with a single folk record. Taking
// a handful from each artist keeps the genres spread out.
const MAX_PER_ARTIST = 4;

// Cover art size. The API hands back a 100x100 thumbnail URL and you ask
// for a bigger version by swapping the size in the URL. 400px is plenty
// for a 260px hero image and keeps the whole folder to a few megabytes,
// which matters when uploading over FTP to free hosting.
const ARTWORK_SIZE = '400x400';

// Be polite to a free public API.
const REQUEST_DELAY_MICROSECONDS = 200000;

$artists = [
    // Rock and alternative
    'Fleetwood Mac', 'Radiohead', 'Led Zeppelin', 'Pink Floyd', 'Queen',
    'David Bowie', 'Nirvana', 'The Rolling Stones', 'Arctic Monkeys',
    'The Smashing Pumpkins', 'R.E.M.', 'Talking Heads',

    // Pop
    'Taylor Swift', 'Michael Jackson', 'Madonna', 'Beyonce', 'Ariana Grande',
    'Kate Bush', 'Robyn',

    // Electronic
    'Daft Punk', 'Aphex Twin', 'The Chemical Brothers', 'Massive Attack',
    'Bonobo', 'Burial', 'Four Tet',

    // Hip-Hop
    'Kendrick Lamar', 'Nas', 'A Tribe Called Quest', 'Outkast',
    'The Roots', 'Run the Jewels',

    // Jazz
    'Miles Davis', 'John Coltrane', 'Bill Evans', 'Herbie Hancock',
    'Thelonious Monk', 'Charles Mingus',

    // Folk and singer-songwriter
    'Joni Mitchell', 'Neil Young', 'Bob Dylan', 'Simon & Garfunkel',
    'Nick Drake', 'Leonard Cohen',

    // Indie
    'Vampire Weekend', 'Lorde', 'The National', 'Sufjan Stevens',
    'Beach House', 'Fleet Foxes', 'Wilco',
];

// Descriptions written by hand. Anything not in here gets a description
// built from its own real metadata further down. Keyed by
// "artist :: title", compared case-insensitively.
$handWritten = [
    'fleetwood mac :: rumours'                       => 'Five band members writing through the collapse of their own relationships, and somehow turning it into the most polished pop-rock record of the decade.',
    'radiohead :: ok computer'                       => 'Guitar music bent into something colder and stranger, full of dread about technology that only reads as more accurate with time.',
    'daft punk :: random access memories'            => 'Two robots hire live session players and disco veterans, then build an album about missing the way records used to sound.',
    'daft punk :: discovery'                         => 'Filtered house built out of chopped-up samples and pure nostalgia, and the record that taught a generation what a French touch drop sounds like.',
    'kendrick lamar :: to pimp a butterfly'          => 'Free jazz, funk and spoken word pulled into a dense record about fame, survivor guilt and Black identity in America.',
    'kendrick lamar :: good kid, m.a.a.d city'       => 'A short film in album form: one day in Compton, told out of order, with the skits doing as much narrative work as the verses.',
    'miles davis :: kind of blue'                    => 'Recorded in two sessions with sketches instead of full charts, letting the band improvise around modes rather than chord changes.',
    'john coltrane :: a love supreme'                => 'A four-part suite written as a devotional offering, moving from restless searching into something close to peace.',
    'joni mitchell :: blue'                          => 'Ten songs with almost nothing to hide behind, mostly voice against dulcimer, piano or open-tuned guitar.',
    'neil young :: harvest'                          => 'Country-leaning songs cut between Nashville, a barn in California and a London orchestra session, and the record that made him far bigger than he wanted to be.',
    'lorde :: melodrama'                             => 'One house party stretched across a whole album, running from the high of the first drink to the walk home alone.',
    'vampire weekend :: modern vampires of the city' => 'The band drop the bright preppy guitars for pitch-shifted vocals and organ, and spend the album arguing with the idea of getting older.',
    'michael jackson :: thriller'                    => 'Pop, funk, rock and disco welded together with studio precision, and still the yardstick every big commercial record gets measured against.',
    'taylor swift :: 1989'                           => 'A full move from country into synth-pop, built on 80s drum sounds and hooks aimed squarely at radio.',
];

// Fallback gradient colours, used underneath the artwork and on their own
// if an album ever ends up without a cover.
$palette = [
    ['#ff6b6b', '#ff9f7f'],
    ['#4d7dff', '#7fb2ff'],
    ['#1fbf9f', '#5fe0c4'],
    ['#8f5bff', '#b98bff'],
    ['#f2b90a', '#ffe07f'],
    ['#ff7ab8', '#ffb3d4'],
];

// Tidy up the genre names the API uses so the filter chips stay readable.
$genreMap = [
    'Hip-Hop/Rap'       => 'Hip-Hop',
    'Rap'               => 'Hip-Hop',
    'R&B/Soul'          => 'Pop',
    'R&B'               => 'Pop',
    'Singer/Songwriter' => 'Folk',
    'Alternative Folk'  => 'Folk',
    'Country'           => 'Pop',
    'Dance'             => 'Electronic',
    'Electronica'       => 'Electronic',
    'Glam Rock'         => 'Rock',
    'Hard Rock'         => 'Rock',
    'Blues'             => 'Rock',
    'Adult Alternative' => 'Alternative',
    'Bop'               => 'Jazz',
    'Hard Bop'          => 'Jazz',
    'Vocal Jazz'        => 'Jazz',
    'Jazz Fusion'       => 'Jazz',
];

// Only these genres end up in the catalogue. Anything the API reports
// that is not on this list, and that genreMap above does not fold into
// one of them, is skipped entirely.
//
// Without this the filter chips fill up with one-album categories like
// "Holiday", "Bop" and "Glam Rock", which look like a mistake on screen.
// Whitelisting is also deterministic: the same genres appear every time
// the script runs, instead of depending on which albums got picked.
$allowedGenres = [
    'Rock', 'Jazz', 'Pop', 'Electronic', 'Alternative',
    'Hip-Hop', 'Folk',
];

// Titles containing any of these are reissues, live records, compilations
// or other things that would clutter a review catalogue.
$rejectPatterns = [
    ' - ep', ' - single', 'karaoke', 'instrumental', 'commentary',
    'tribute', 'live at', 'live in', 'live from', '(live', 'unplugged',
    'greatest hits', 'best of', 'the essential', 'anthology', 'b-sides',
    'remixes', 'remixed', 'demos', 'rarities', 'box set', 'in concert',
    'a cappella', 'collection', 'sessions', 'very best', 'hits',
    'bootleg series', 'christmas', 'the songs of', 'soundtrack from',
    'original score', 'radio', 'outtakes', 'alternate',
    'live 19', 'live 20', 'live!', 'concert',
];

function api_get(string $url): ?array
{
    $json = @file_get_contents($url);
    usleep(REQUEST_DELAY_MICROSECONDS);

    return $json ? json_decode($json, true) : null;
}

// Strips edition suffixes so "Rumours (2004 Remaster)", "Rumours [Deluxe]"
// and "Rumours" all collapse to the same key. That is what lets us keep
// one copy of an album instead of five editions of it.
function base_title(string $title): string
{
    $title = preg_replace('/[\(\[].*?[\)\]]/', '', $title);
    $title = preg_replace('/\s*-\s*(deluxe|remaster(ed)?|expanded|anniversary|special|legacy).*$/i', '', $title);
    $title = strtolower($title);
    $title = preg_replace('/[^a-z0-9 ]/', '', $title);

    return trim(preg_replace('/\s+/', ' ', $title));
}

// Cleans up the title we actually display. The API returns things like
// "Mirage (Remastered)", "Diamond Dogs (2016 Remaster)" and "Le Noise
// (Deluxe Version)", where the bracketed part describes the reissue
// rather than the album. Only known edition wording is removed, so a
// title where the brackets are part of the name survives intact.
function display_title(string $title): string
{
    $editionWords = 'remaster(ed)?|deluxe|expanded|anniversary|special edition'
        . '|legacy edition|super deluxe|bonus track|reissue|taylor\'?s version'
        . '|mono|stereo|version';

    // Bracketed: "Mirage (Remastered)", "Diamond Dogs [2016 Remaster]"
    $title = preg_replace(
        '/\s*[\(\[][^\)\]]*(' . $editionWords . ')[^\)\]]*[\)\]]/i',
        '',
        $title
    );

    // Trailing dash form: "Rumours - Deluxe Edition"
    $title = preg_replace('/\s*-\s*(' . $editionWords . ').*$/i', '', $title);

    return trim($title);
}

// The API returns the label inside a copyright line like
// "℗ 2004 Warner Records Inc." - strip the symbol and the year off it.
function label_from_copyright(?string $copyright): ?string
{
    if (!$copyright) {
        return null;
    }

    $label = preg_replace('/^[^\p{L}\d]*/u', '', $copyright);
    $label = preg_replace('/^\d{4}\s*/', '', $label);
    $label = trim($label);

    return $label !== '' ? mb_substr($label, 0, 150) : null;
}

// Builds a description out of the album's own real metadata. Several
// shapes are rotated through, and clauses are dropped when the data
// behind them is missing, so the results are not all identically worded.
function generated_description(array $album, int $variant): string
{
    $genre = strtolower($album['genre']);
    $tracks = $album['track_count'];
    $mins = $album['duration_min'];
    $year = $album['year'];
    $artist = $album['artist'];
    $title = $album['title'];
    $label = $album['label'];

    $length = $mins > 0 ? "{$tracks} tracks across about {$mins} minutes" : "{$tracks} tracks";
    $shortLength = $mins > 0 ? "{$tracks} tracks, about {$mins} minutes" : "{$tracks} tracks";

    // Labels often already end in a full stop ("Warner Records Inc."),
    // which would collide with the one ending the sentence and print as
    // "Inc..". Trim it off before building the sentence.
    $on = $label ? ' on ' . rtrim($label, '.') : '';

    $shapes = [
        "{$artist} released {$title} in {$year}. {$length} of {$genre}.",
        "A {$genre} record from {$artist}, originally released in {$year}{$on}. {$shortLength}.",
        "{$title} is {$artist}'s {$genre} album from {$year}, collecting {$length}.",
        "Out in {$year}{$on}, {$title} gathers {$length} of {$genre} from {$artist}.",
        "{$artist}'s {$year} {$genre} album. {$shortLength}.",
        "Released in {$year}, {$title} runs to {$length} of {$genre} from {$artist}.",
    ];

    return $shapes[$variant % count($shapes)];
}

$coversDir = __DIR__ . '/../assets/covers';
if (!is_dir($coversDir)) {
    mkdir($coversDir, 0777, true);
}

// Wipe any previously downloaded artwork so deleted albums do not leave
// orphaned image files behind.
foreach (glob($coversDir . '/*.jpg') as $oldCover) {
    unlink($oldCover);
}

echo "Clearing existing albums...\n";
db()->exec('DELETE FROM albums');
db()->exec('ALTER TABLE albums AUTO_INCREMENT = 1');

// ---------------------------------------------------------------------
// Step 1: collect candidate albums from the API, before touching the DB.
// ---------------------------------------------------------------------
$candidates = [];

foreach ($artists as $artistName) {
    // Resolve the artist name to Apple's numeric artist id, so the album
    // lookup returns that artist's real discography instead of a keyword
    // search full of covers and karaoke versions.
    $found = api_get('https://itunes.apple.com/search?' . http_build_query([
        'term'   => $artistName,
        'entity' => 'musicArtist',
        'limit'  => 1,
    ]));

    $artistId = $found['results'][0]['artistId'] ?? null;
    if (!$artistId) {
        echo "  no artist id: {$artistName}\n";
        continue;
    }

    $data = api_get('https://itunes.apple.com/lookup?' . http_build_query([
        'id'     => $artistId,
        'entity' => 'album',
        'limit'  => 200,
    ]));

    $seenTitles = [];
    $kept = 0;

    foreach ($data['results'] ?? [] as $row) {
        if (($row['collectionType'] ?? '') !== 'Album') {
            continue; // the first result is the artist record itself
        }

        $title = $row['collectionName'] ?? '';
        $lowerTitle = strtolower($title);

        // Drop EPs, live albums, compilations and similar.
        foreach ($rejectPatterns as $pattern) {
            if (strpos($lowerTitle, $pattern) !== false) {
                continue 2;
            }
        }

        // Drop anything too short to be a real album.
        if ((int) ($row['trackCount'] ?? 0) < 6) {
            continue;
        }

        // Keep only the first edition of each album we see.
        $key = base_title($title);
        if ($key === '' || isset($seenTitles[$key])) {
            continue;
        }
        $seenTitles[$key] = true;

        if ($kept >= MAX_PER_ARTIST) {
            break;
        }

        $rawGenre = $row['primaryGenreName'] ?? 'Other';
        $genre = $genreMap[$rawGenre] ?? $rawGenre;

        // Skip anything that isn't one of the catalogue's genres.
        if (!in_array($genre, $allowedGenres, true)) {
            continue;
        }

        $candidates[] = [
            'collection_id' => (int) $row['collectionId'],
            'title'         => display_title($title),
            'artist'        => $row['artistName'] ?? $artistName,
            'year'          => (int) substr($row['releaseDate'] ?? '0000', 0, 4),
            'genre'         => $genre,
            'label'         => label_from_copyright($row['copyright'] ?? null),
            'track_count'   => (int) $row['trackCount'],
            'artwork'       => str_replace('100x100bb', ARTWORK_SIZE . 'bb', $row['artworkUrl100'] ?? ''),
        ];
        $kept++;
    }

    echo "  {$artistName}: {$kept} albums\n";
}

echo "\nCollected " . count($candidates) . " candidate albums.\n";

// Spread the artists out rather than inserting one artist's whole
// discography in a block, so the random home page and the A-Z listing
// both look varied.
shuffle($candidates);
$candidates = array_slice($candidates, 0, TARGET_ALBUMS);

// ---------------------------------------------------------------------
// Step 2: fetch runtime, download artwork, and insert.
// ---------------------------------------------------------------------
$insert = db()->prepare(
    'INSERT INTO albums
        (title, artist, year, genre, label, producer, track_count, duration_min, description, cover_url, cover_color_1, cover_color_2)
     VALUES
        (:title, :artist, :year, :genre, :label, NULL, :track_count, :duration_min, :description, :cover_url, :c1, :c2)'
);

$inserted = 0;

foreach ($candidates as $index => $album) {
    // Album runtime is not a field the API exposes, so add up the length
    // of every track on the record.
    $songs = api_get('https://itunes.apple.com/lookup?' . http_build_query([
        'id'     => $album['collection_id'],
        'entity' => 'song',
        'limit'  => 200,
    ]));

    $milliseconds = 0;
    foreach ($songs['results'] ?? [] as $song) {
        $milliseconds += (int) ($song['trackTimeMillis'] ?? 0);
    }
    $album['duration_min'] = (int) round($milliseconds / 60000);

    $key = strtolower($album['artist'] . ' :: ' . $album['title']);
    $description = $handWritten[$key] ?? generated_description($album, $index);

    $colors = $palette[$index % count($palette)];

    $insert->execute([
        'title'        => $album['title'],
        'artist'       => $album['artist'],
        'year'         => $album['year'],
        'genre'        => $album['genre'],
        'label'        => $album['label'],
        'track_count'  => $album['track_count'],
        'duration_min' => $album['duration_min'],
        'description'  => $description,
        'cover_url'    => null,
        'c1'           => $colors[0],
        'c2'           => $colors[1],
    ]);

    $albumId = (int) db()->lastInsertId();

    $imageData = $album['artwork'] ? @file_get_contents($album['artwork']) : false;
    if ($imageData !== false) {
        file_put_contents($coversDir . '/' . $albumId . '.jpg', $imageData);
        db()->prepare('UPDATE albums SET cover_url = :url WHERE id = :id')
            ->execute(['url' => 'assets/covers/' . $albumId . '.jpg', 'id' => $albumId]);
    }

    $inserted++;
    if ($inserted % 25 === 0) {
        echo "  inserted {$inserted}...\n";
    }
}

$total = db()->query('SELECT COUNT(*) FROM albums')->fetchColumn();
$genres = db()->query('SELECT COUNT(DISTINCT genre) FROM albums')->fetchColumn();
echo "\nDone. {$total} albums across {$genres} genres.\n";
