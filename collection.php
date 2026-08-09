<?php
// Crate - "Your Favourites" page
// require_login() sends anyone who isn't logged in straight to login.php -
// there's no sensible logged-out version of this page, so we don't even
// try to render one.

require_once __DIR__ . '/includes/auth.php';
require_login();

$pageTitle = SITE_NAME . ' - Favourites';
require_once __DIR__ . '/includes/header.php';
?>

<div id="app">
    <h1>Your Favourites</h1>

    <p v-if="loading">Loading...</p>
    <p v-else-if="albums.length === 0">
        You haven't favourited any albums yet. <a href="index.php">Browse albums</a>.
    </p>

    <div v-else class="album-grid">
        <a
            v-for="album in albums"
            :key="album.id"
            :href="'album.php?id=' + album.id"
            class="album-card"
            :style="{ background: 'linear-gradient(135deg, ' + album.cover_color_1 + ', ' + album.cover_color_2 + ')' }"
        >
            <button
                type="button"
                class="heart-btn favourited"
                @click.stop.prevent="removeFavourite(album.id)"
            >♥</button>

            <div class="album-card-info">
                <strong>{{ album.title }}</strong>
                <span>{{ album.artist }}</span>
            </div>
        </a>
    </div>
</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="js/collection.js"></script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
