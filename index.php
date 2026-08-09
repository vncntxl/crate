<?php
// Crate - home page
// This file is deliberately "thin": it does almost no work itself. It just
// sets a page title, includes the shared header/footer, and drops in the
// one <div id="app"> that Vue will take over. All the real logic - loading
// albums, searching, filtering - lives in js/app.js.

require_once __DIR__ . '/includes/header.php';
?>

<div id="app">
    <h1>Browse Albums</h1>

    <div class="controls">
        <input
            type="text"
            v-model="searchTerm"
            @input="onSearchInput"
            placeholder="Search by title or artist..."
        >

        <div class="genre-chips">
            <button
                v-for="genre in genres"
                :key="genre"
                type="button"
                :class="{ active: genre === activeGenre }"
                @click="filterByGenre(genre)"
            >{{ genre }}</button>

            <button v-if="activeGenre" type="button" @click="filterByGenre('')">
                Clear filter
            </button>
        </div>
    </div>

    <p v-if="loading">Loading albums...</p>
    <p v-else-if="albums.length === 0" class="empty-state">No albums found.</p>

    <div v-else class="album-grid">
        <a
            v-for="album in albums"
            :key="album.id"
            :href="'album.php?id=' + album.id"
            class="album-card"
            :style="{ background: 'linear-gradient(135deg, ' + album.cover_color_1 + ', ' + album.cover_color_2 + ')' }"
        >
            <!--
                Real cover art when we have it. The gradient set on the
                card above stays as the fallback, so an album added
                through the admin form (which has no artwork) still shows
                something rather than an empty square.
            -->
            <img
                v-if="album.cover_url"
                :src="album.cover_url"
                :alt="album.title + ' album cover'"
                class="album-card-art"
            >

            <!--
                PHP already knows on the server whether you're logged in,
                so it writes the literal word "true" or "false" straight
                into this v-if - Vue doesn't need to work that out itself.
                @click.stop.prevent stops the click from also triggering
                the <a>'s normal "go to the album" navigation.
            -->
            <button
                v-if="<?= $loggedInUser ? 'true' : 'false' ?>"
                type="button"
                class="heart-btn"
                :class="{ favourited: favouriteIds.includes(album.id) }"
                @click.stop.prevent="toggleFavourite(album.id)"
            >♥</button>

            <div class="album-card-info">
                <strong>{{ album.title }}</strong>
                <span>{{ album.artist }}</span>
            </div>
        </a>
    </div>
</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="js/app.js"></script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
