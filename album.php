<?php
// Crate - album detail page
// Like index.php, this is a thin shell. The only PHP work it does is read
// the album id from the URL (?id=5) and check it's a sensible number
// before handing off to Vue - everything else is fetched as JSON.

require_once __DIR__ . '/includes/auth.php';

$albumId = (int) ($_GET['id'] ?? 0);

if ($albumId <= 0) {
    header('Location: index.php');
    exit;
}

$pageTitle = SITE_NAME . ' - Album';
require_once __DIR__ . '/includes/header.php';
?>

<!--
    data-album-id: index.php doesn't need to know which album to load, but
    this page does. Instead of making js/album.js re-parse window.location
    itself, PHP (which already read ?id= above) writes the number straight
    onto this element, and Vue just reads it back in mounted().
-->
<div id="app" data-album-id="<?= $albumId ?>">
    <p v-if="loading">Loading album...</p>
    <p v-else-if="!album" class="empty-state">Album not found.</p>

    <div v-else class="album-detail">
        <div
            class="album-hero"
            :style="{ background: 'linear-gradient(135deg, ' + album.cover_color_1 + ', ' + album.cover_color_2 + ')' }"
        ></div>

        <div class="album-info">
            <div class="detail-title-row">
                <h1>{{ album.title }}</h1>

                <?php if ($loggedInUser): ?>
                    <button
                        type="button"
                        class="heart-btn detail-heart"
                        :class="{ favourited: isFavourited }"
                        @click="toggleFavourite"
                    >♥ {{ isFavourited ? 'Favourited' : 'Add to favourites' }}</button>
                <?php endif; ?>
            </div>

            <p class="artist">{{ album.artist }} &middot; {{ album.year }} &middot; {{ album.genre }}</p>

            <div class="rating-line">
                <star-rating v-if="averageRating !== null" :rating="averageRating"></star-rating>
                <span v-if="averageRating !== null">
                    {{ averageRating }} / 5 ({{ reviewCount }} review{{ reviewCount === 1 ? '' : 's' }})
                </span>
                <span v-else>No reviews yet.</span>
            </div>

            <p class="description">{{ album.description }}</p>

            <dl class="meta">
                <dt>Label</dt><dd>{{ album.label || '—' }}</dd>
                <dt>Producer</dt><dd>{{ album.producer || '—' }}</dd>
                <dt>Tracks</dt><dd>{{ album.track_count }}</dd>
                <dt>Duration</dt><dd>{{ album.duration_min }} min</dd>
            </dl>
        </div>

        <section class="write-review">
            <h2>{{ myReviewId ? 'Edit your review' : 'Write a review' }}</h2>

            <?php if ($loggedInUser): ?>
                <form @submit.prevent="submitReview" class="review-form">
                    <star-picker v-model="myRating"></star-picker>

                    <textarea
                        v-model="myReviewText"
                        placeholder="What did you think? (optional)"
                        rows="3"
                    ></textarea>

                    <p v-if="reviewError" class="form-errors-inline">{{ reviewError }}</p>

                    <button type="submit" :disabled="myRating === 0 || submitting">
                        {{ submitting ? 'Saving...' : (myReviewId ? 'Update review' : 'Submit review') }}
                    </button>
                </form>
            <?php else: ?>
                <p><a href="login.php">Log in</a> to write a review.</p>
            <?php endif; ?>
        </section>

        <section class="reviews">
            <h2>Reviews</h2>

            <p v-if="reviews.length === 0" class="empty-state">No one has reviewed this album yet.</p>

            <div v-for="review in reviews" :key="review.id" class="review">
                <div class="review-head">
                    <strong>{{ review.user_name }}</strong>
                    <star-rating :rating="review.rating"></star-rating>
                </div>
                <p v-if="review.review_text" class="review-text">{{ review.review_text }}</p>
            </div>
        </section>
    </div>
</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="js/album.js"></script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
