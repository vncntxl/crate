// Crate - "Your Favourites" page Vue app
// Loads the logged-in user's favourited albums and lets them remove one
// straight from this grid.

const { createApp } = Vue;

createApp({
    data() {
        return {
            albums: [],
            loading: true,
        };
    },

    mounted() {
        this.loadFavourites();
    },

    methods: {
        async loadFavourites() {
            this.loading = true;
            const response = await fetch('api/favourites.php');
            this.albums = await response.json();
            this.loading = false;
        },

        // Every card on this page is already favourited, so clicking its
        // heart always means "remove". We update the local list straight
        // away instead of re-fetching the whole page from the server.
        async removeFavourite(albumId) {
            const body = new URLSearchParams();
            body.set('album_id', albumId);

            await fetch('api/favourite_toggle.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });

            this.albums = this.albums.filter((album) => album.id !== albumId);
        },
    },
}).mount('#app');
