// Crate - admin "add album" page Vue app

const { createApp } = Vue;

createApp({
    data() {
        const currentYear = new Date().getFullYear();

        return {
            title: '',
            artist: '',
            year: currentYear,
            genre: '',
            labelName: '',
            producer: '',
            trackCount: null,
            durationMin: null,
            description: '',
            currentYear,

            errors: [],
            successMessage: '',
            submitting: false,
        };
    },

    methods: {
        // Client-side validation. This exists purely for a fast, friendly
        // "you missed a field" message without waiting on a round trip
        // to the server. It is NOT the real security boundary - anyone
        // can bypass this JavaScript (browser devtools, curl, a disabled
        // -JS browser) and POST straight to api/album_add.php, which is
        // why that file re-checks every one of these rules itself.
        validate() {
            const errors = [];
            if (this.title.trim() === '') errors.push('Title is required.');
            if (this.artist.trim() === '') errors.push('Artist is required.');
            if (this.genre.trim() === '') errors.push('Genre is required.');
            if (!this.year || this.year < 1900 || this.year > this.currentYear) {
                errors.push('Enter a valid year.');
            }
            return errors;
        },

        async submitAlbum() {
            this.errors = this.validate();
            this.successMessage = '';

            if (this.errors.length > 0) {
                return;
            }

            this.submitting = true;

            const body = new URLSearchParams();
            body.set('title', this.title);
            body.set('artist', this.artist);
            body.set('year', this.year);
            body.set('genre', this.genre);
            body.set('label', this.labelName);
            body.set('producer', this.producer);
            body.set('track_count', this.trackCount ?? '');
            body.set('duration_min', this.durationMin ?? '');
            body.set('description', this.description);

            const response = await fetch('api/album_add.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body.toString(),
            });
            const data = await response.json();

            if (!response.ok) {
                this.errors = [data.error || 'Could not add album.'];
                this.submitting = false;
                return;
            }

            this.successMessage = `"${this.title}" was added.`;
            this.title = '';
            this.artist = '';
            this.genre = '';
            this.labelName = '';
            this.producer = '';
            this.trackCount = null;
            this.durationMin = null;
            this.description = '';
            this.submitting = false;
        },
    },
}).mount('#app');
