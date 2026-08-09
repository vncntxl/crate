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

createApp({
    data() {
        return {
            albumId: null,
            album: null,
            reviews: [],
            averageRating: null,
            reviewCount: 0,
            loading: true,
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

            this.loading = false;
        },
    },
})
    .component('star-rating', StarRating)
    .mount('#app');
