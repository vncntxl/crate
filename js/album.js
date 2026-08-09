// Crate - album detail page Vue app
// Loads one album's full details, its reviews, and its average rating
// from api/album.php and renders them.

const { createApp } = Vue;

// A small reusable component that draws a row of five stars (e.g. ★★★☆☆).
// We need this in two places on this page - the album's average rating,
// and every individual review below it - so instead of writing the same
// five-star markup twice, we define it once as a component and pass in
// a different `rating` number each time via a prop.
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

// A second component, distinct from StarRating above: this one is
// clickable. It uses Vue's v-model pattern - the parent passes in a
// `modelValue` prop, and this component emits an 'update:modelValue'
// event whenever a star is clicked. That two-way pairing is exactly what
// v-model="myRating" on <star-picker> in album.php wires up for us.
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
        return {
            albumId: null,
            album: null,
            reviews: [],
            averageRating: null,
            reviewCount: 0,
            loading: true,

            // "my" review - the logged-in user's own rating/text for this
            // album, used to fill in the review form below.
            myReviewId: null,
            myRating: 0,
            myReviewText: '',
            reviewError: '',
            submitting: false,
        };
    },

    mounted() {
        // Read the album id that album.php wrote onto the #app element.
        this.albumId = document.getElementById('app').dataset.albumId;
        this.loadAlbum();
    },

    methods: {
        async loadAlbum() {
            this.loading = true;

            const response = await fetch('api/album.php?id=' + this.albumId);
            const data = await response.json();

            this.album = data.album ?? null;
            this.reviews = data.reviews ?? [];
            this.averageRating = data.average_rating;
            this.reviewCount = data.review_count ?? 0;

            // If the API told us we already have a review for this album,
            // pre-fill the form so the button says "Update review"
            // instead of creating a duplicate.
            if (data.my_review) {
                this.myReviewId = data.my_review.id;
                this.myRating = data.my_review.rating;
                this.myReviewText = data.my_review.review_text || '';
            } else {
                this.myReviewId = null;
                this.myRating = 0;
                this.myReviewText = '';
            }

            this.loading = false;
        },

        // Sends the star-picker's value and the textarea's text to
        // api/review_add.php. That endpoint decides for itself whether
        // this is a brand new review or an update to an existing one, so
        // this method doesn't need to know or care which.
        async submitReview() {
            this.submitting = true;
            this.reviewError = '';

            const body = new URLSearchParams();
            body.set('album_id', this.albumId);
            body.set('rating', this.myRating);
            body.set('review_text', this.myReviewText);

            const response = await fetch('api/review_add.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });
            const data = await response.json();

            if (!response.ok) {
                this.reviewError = data.error || 'Could not save review.';
                this.submitting = false;
                return;
            }

            // Reload everything from the server. This is what makes the
            // new/updated review, and the recalculated average rating,
            // show up immediately - without a full page reload.
            await this.loadAlbum();
            this.submitting = false;
        },
    },
})
    .component('star-rating', StarRating)
    .component('star-picker', StarPicker)
    .mount('#app');
