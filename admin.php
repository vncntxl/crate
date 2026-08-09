<?php
// Crate - admin: add album page
// require_admin() (in includes/auth.php) checks BOTH that someone is
// logged in AND that their is_admin flag is set, and stops the page dead
// with a 403 if not. This is the actual gate - the "Admin" link only
// showing up in the nav for admins (see includes/header.php) is just a
// convenience on top of it.

require_once __DIR__ . '/includes/auth.php';
require_admin();

$pageTitle = SITE_NAME . ' - Admin';
require_once __DIR__ . '/includes/header.php';
?>

<div id="app">
    <h1>Add an Album</h1>

    <form @submit.prevent="submitAlbum" class="auth-form album-form">
        <label>
            Title
            <input type="text" v-model="title" required>
        </label>

        <label>
            Artist
            <input type="text" v-model="artist" required>
        </label>

        <label>
            Year
            <input type="number" v-model.number="year" :max="currentYear" min="1900" required>
        </label>

        <label>
            Genre
            <input type="text" v-model="genre" required>
        </label>

        <label>
            Label
            <input type="text" v-model="labelName">
        </label>

        <label>
            Producer
            <input type="text" v-model="producer">
        </label>

        <label>
            Track count
            <input type="number" v-model.number="trackCount" min="1">
        </label>

        <label>
            Duration (minutes)
            <input type="number" v-model.number="durationMin" min="1">
        </label>

        <label>
            Cover image URL (optional)
            <input type="url" v-model="coverUrl" placeholder="https://example.com/cover.jpg">
        </label>

        <!-- Live preview, so a mistyped URL is obvious before saving -->
        <div v-if="coverUrl" class="cover-preview">
            <img :src="coverUrl" alt="Cover preview" @error="coverBroken = true" @load="coverBroken = false">
            <span v-if="coverBroken" class="form-errors-inline">That image could not be loaded.</span>
        </div>

        <label>
            Description
            <textarea v-model="description" rows="4"></textarea>
        </label>

        <div v-if="errors.length" class="form-errors">
            <div v-for="err in errors" :key="err">{{ err }}</div>
        </div>
        <p v-if="successMessage" class="form-success-inline">{{ successMessage }}</p>

        <button type="submit" :disabled="submitting">
            {{ submitting ? 'Adding...' : 'Add album' }}
        </button>
    </form>
</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="<?= asset('js/admin.js') ?>"></script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
