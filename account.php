<?php
// Crate - account page
// require_login() bounces guests to login.php - everything below assumes
// someone is actually logged in.

require_once __DIR__ . '/includes/auth.php';
require_login();

$pageTitle = SITE_NAME . ' - Account';
require_once __DIR__ . '/includes/header.php';
?>

<!--
    data-user-name / data-user-email: PHP already knows who's logged in
    (it just ran require_login() above), so it writes the current name
    and email straight onto this element. Vue reads them back in
    data() to pre-fill the profile form instead of making a separate
    fetch() just to ask "who am I?".
-->
<div id="app" data-user-name="<?= e($loggedInUser['name']) ?>" data-user-email="<?= e($loggedInUser['email']) ?>">
    <h1>Your Account</h1>

    <section class="account-section">
        <h2>Profile</h2>

        <form @submit.prevent="updateProfile" class="auth-form">
            <label>
                Name
                <input type="text" v-model="profileName" required>
            </label>

            <label>
                Email
                <input type="email" v-model="profileEmail" required>
            </label>

            <p v-if="profileError" class="form-errors-inline">{{ profileError }}</p>
            <p v-if="profileSuccess" class="form-success-inline">{{ profileSuccess }}</p>

            <button type="submit" :disabled="profileSaving">
                {{ profileSaving ? 'Saving...' : 'Save changes' }}
            </button>
        </form>
    </section>

    <section class="account-section">
        <h2>Change password</h2>

        <form @submit.prevent="changePassword" class="auth-form">
            <label>
                Current password
                <input type="password" v-model="currentPassword" required>
            </label>

            <label>
                New password
                <input type="password" v-model="newPassword" minlength="8" required>
            </label>

            <label>
                Confirm new password
                <input type="password" v-model="newPasswordConfirm" minlength="8" required>
            </label>

            <p v-if="passwordError" class="form-errors-inline">{{ passwordError }}</p>
            <p v-if="passwordSuccess" class="form-success-inline">{{ passwordSuccess }}</p>

            <button type="submit" :disabled="passwordSaving">
                {{ passwordSaving ? 'Saving...' : 'Change password' }}
            </button>
        </form>
    </section>

    <section class="account-section">
        <h2>Your reviews</h2>

        <p v-if="loadingReviews">Loading...</p>
        <p v-else-if="reviews.length === 0">You haven't written any reviews yet.</p>

        <div v-for="review in reviews" :key="review.id" class="my-review">
            <!-- Normal display mode -->
            <div v-if="editingId !== review.id" class="my-review-view">
                <div class="my-review-head">
                    <a :href="'album.php?id=' + review.album_id">{{ review.album_title }}</a>
                    <span class="artist">{{ review.album_artist }}</span>
                    <star-rating :rating="review.rating"></star-rating>
                </div>
                <p v-if="review.review_text" class="review-text">{{ review.review_text }}</p>
                <div class="my-review-actions">
                    <button type="button" @click="startEdit(review)">Edit</button>
                    <button type="button" @click="deleteReview(review.id)">Delete</button>
                </div>
            </div>

            <!-- Edit mode: swaps in a small form for just this one review -->
            <form v-else @submit.prevent="saveEdit(review)" class="review-form">
                <star-picker v-model="editRating"></star-picker>
                <textarea v-model="editText" rows="3"></textarea>
                <div class="my-review-actions">
                    <button type="submit">Save</button>
                    <button type="button" @click="cancelEdit">Cancel</button>
                </div>
            </form>
        </div>
    </section>
</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="js/account.js"></script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
