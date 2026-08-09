// Crate - account page Vue app
// Three independent jobs on one page: edit profile, change password, and
// manage your own reviews. They don't depend on each other, so they're
// just three separate groups of data/methods living in the same app.

const { createApp } = Vue;

// Same read-only star display used on the home and album pages. Since we
// load Vue straight from a CDN with plain <script> tags (no bundler, no
// import/export), each page's JS file is self-contained and just
// redefines the small components it needs.
const StarRating = {
    props: {
        rating: {
            type: Number,
            required: true,
        },
    },
    template: `
        <span class="star-rating">
            <span v-for="n in 5" :key="n" :class="{ filled: n <= Math.round(rating) }">★</span>
        </span>
    `,
};

const StarPicker = {
    props: {
        modelValue: {
            type: Number,
            default: 0,
        },
    },
    emits: ['update:modelValue'],
    template: `
        <span class="star-picker">
            <button
                v-for="n in 5"
                :key="n"
                type="button"
                :class="{ filled: n <= modelValue }"
                @click="$emit('update:modelValue', n)"
            >★</button>
        </span>
    `,
};

createApp({
    data() {
        // Read the name/email PHP wrote onto the #app element so the
        // profile form starts pre-filled with the real current values.
        const el = document.getElementById('app');

        return {
            // Profile form
            profileName: el.dataset.userName,
            profileEmail: el.dataset.userEmail,
            profileError: '',
            profileSuccess: '',
            profileSaving: false,

            // Password form
            currentPassword: '',
            newPassword: '',
            newPasswordConfirm: '',
            passwordError: '',
            passwordSuccess: '',
            passwordSaving: false,

            // "Your reviews" list
            reviews: [],
            loadingReviews: true,
            editingId: null,   // id of the review currently being edited, or null
            editRating: 0,
            editText: '',
        };
    },

    mounted() {
        this.loadReviews();
    },

    methods: {
        async updateProfile() {
            this.profileSaving = true;
            this.profileError = '';
            this.profileSuccess = '';

            const body = new URLSearchParams();
            body.set('name', this.profileName);
            body.set('email', this.profileEmail);

            const response = await fetch('api/account_update.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });
            const data = await response.json();

            if (!response.ok) {
                this.profileError = data.error || 'Could not save changes.';
            } else {
                this.profileSuccess = 'Saved.';
            }

            this.profileSaving = false;
        },

        async changePassword() {
            this.passwordSaving = true;
            this.passwordError = '';
            this.passwordSuccess = '';

            const body = new URLSearchParams();
            body.set('current_password', this.currentPassword);
            body.set('new_password', this.newPassword);
            body.set('new_password_confirm', this.newPasswordConfirm);

            const response = await fetch('api/password_change.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });
            const data = await response.json();

            if (!response.ok) {
                this.passwordError = data.error || 'Could not change password.';
            } else {
                this.passwordSuccess = 'Password changed.';
                this.currentPassword = '';
                this.newPassword = '';
                this.newPasswordConfirm = '';
            }

            this.passwordSaving = false;
        },

        async loadReviews() {
            this.loadingReviews = true;
            const response = await fetch('api/my_reviews.php');
            this.reviews = await response.json();
            this.loadingReviews = false;
        },

        startEdit(review) {
            this.editingId = review.id;
            this.editRating = review.rating;
            this.editText = review.review_text || '';
        },

        cancelEdit() {
            this.editingId = null;
        },

        async saveEdit(review) {
            const body = new URLSearchParams();
            body.set('album_id', review.album_id);
            body.set('rating', this.editRating);
            body.set('review_text', this.editText);

            // api/review_add.php already knows how to update an existing
            // review instead of creating a duplicate (it looks for one
            // matching this user_id + album_id) - so editing from here
            // uses the exact same endpoint the album page's review form
            // uses.
            await fetch('api/review_add.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });

            this.editingId = null;
            this.loadReviews();
        },

        async deleteReview(id) {
            const body = new URLSearchParams();
            body.set('id', id);

            await fetch('api/review_delete.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });

            this.reviews = this.reviews.filter((review) => review.id !== id);
        },
    },
})
    .component('star-rating', StarRating)
    .component('star-picker', StarPicker)
    .mount('#app');
