// Crate - home page Vue app
//
// createApp({...}) builds a Vue application out of a plain JS object.
// .mount('#app') tells Vue "take control of the <div id="app"> in
// index.php, and everything inside it." From that point on, Vue watches
// the data below and automatically re-draws any part of the HTML that
// uses it whenever it changes - we never touch the DOM by hand.

const { createApp } = Vue;

createApp({
    // data() returns everything this page needs to remember. Every
    // property in here is "reactive" - Vue tracks it, and the template in
    // index.php re-renders automatically whenever one of these changes.
    data() {
        return {
            albums: [],       // albums currently shown in the grid
            genres: [],       // genre names for the filter chips
            searchTerm: '',   // whatever the user has typed in the search box
            activeGenre: '',  // the currently selected genre chip ('' = none)
            loading: true,    // true while a fetch() is in flight
            favouriteIds: [], // album ids the logged-in user has hearted
        };
    },

    // mounted() runs once, right after Vue has attached to the page. This
    // is where we do our first data load.
    mounted() {
        // If the user arrived here via the "Genres" nav dropdown
        // (index.php?genre=Rock), start already filtered to that genre.
        const urlParams = new URLSearchParams(window.location.search);
        const genreFromUrl = urlParams.get('genre');
        if (genreFromUrl) {
            this.activeGenre = genreFromUrl;
        }

        this.loadGenres();
        this.loadAlbums();
        this.loadFavourites();
    },

    methods: {
        // Runs on every keystroke in the search box. Typing a search term
        // and picking a genre chip are two different ways to filter, and
        // only one applies at a time (see the elseif in api/albums.php) -
        // so as soon as the user starts typing, we drop any active genre
        // chip to keep the highlighted button honest about what's
        // actually being used to filter the results.
        onSearchInput() {
            if (this.searchTerm.trim() !== '') {
                this.activeGenre = '';
            }
            this.loadAlbums();
        },

        // Asks api/albums.php for the albums that match the current search
        // term or genre filter (or, if neither is set, a random 8).
        async loadAlbums() {
            this.loading = true;

            // URLSearchParams builds a query string like "?q=moon" for us
            // safely, so we don't have to glue strings together by hand.
            const params = new URLSearchParams();
            if (this.searchTerm.trim() !== '') {
                params.set('q', this.searchTerm.trim());
            } else if (this.activeGenre !== '') {
                params.set('genre', this.activeGenre);
            }

            const response = await fetch('api/albums.php?' + params.toString());
            this.albums = await response.json();
            this.loading = false;
        },

        // Loads the distinct genre list once, for the filter chip buttons.
        async loadGenres() {
            const response = await fetch('api/genres.php');
            this.genres = await response.json();
        },

        // Runs when a genre chip is clicked. Picking a genre clears the
        // search box, since "search" and "browse by genre" are two
        // different ways to filter and we only apply one at a time
        // (see the elseif in api/albums.php).
        filterByGenre(genre) {
            this.activeGenre = genre;
            this.searchTerm = '';
            this.loadAlbums();
        },

        // Loads the ids of every album the logged-in user has favourited,
        // so the heart buttons in the grid know which ones to fill in.
        // If nobody is logged in, api/favourites.php replies 401 and we
        // just leave the list empty (the hearts aren't even shown then -
        // see the v-if on the heart button in index.php).
        async loadFavourites() {
            const response = await fetch('api/favourites.php');
            if (!response.ok) {
                this.favouriteIds = [];
                return;
            }
            const albums = await response.json();
            this.favouriteIds = albums.map((album) => album.id);
        },

        // Runs when a heart button is clicked. Posts to the toggle
        // endpoint, then updates our local favouriteIds list to match
        // whatever the server says actually happened - this is what
        // makes the heart fill in or empty out immediately.
        async toggleFavourite(albumId) {
            const body = new URLSearchParams();
            body.set('album_id', albumId);

            const response = await fetch('api/favourite_toggle.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });
            const data = await response.json();

            if (data.favourited) {
                this.favouriteIds.push(albumId);
            } else {
                this.favouriteIds = this.favouriteIds.filter((id) => id !== albumId);
            }
        },
    },
}).mount('#app');
