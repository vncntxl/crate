# Album Detail Page, Star Ratings, and Reviews

**Files:** `album.php`, `js/album.js`, `api/album.php`, `api/review_add.php`, `api/review_delete.php`

## Getting the album id from the URL to Vue

`album.php` reads `?id=5` from the URL in plain PHP:

```php
$albumId = (int) ($_GET['id'] ?? 0);
```

Rather than making `js/album.js` re-parse `window.location` itself, PHP
writes that number straight onto the mount point:

```php
<div id="app" data-album-id="<?= $albumId ?>">
```

and Vue reads it back once, in `mounted()`:

```js
this.albumId = document.getElementById('app').dataset.albumId;
```

This `data-*` attribute pattern shows up again for the account page's
current name and email. The general technique: PHP already knows this
value server-side, so hand it to Vue directly instead of asking the
browser to re-derive it.

## `api/album.php`: one endpoint, four things

Given `?id=`, this returns:

1. The album row itself.
2. Every review for it, `JOIN`ed with `users` to include the reviewer's
   name, so the front end doesn't need a second request just to know
   who wrote each review.
3. The average rating and review count, calculated in SQL:
   `SELECT AVG(rating), COUNT(*) FROM reviews WHERE album_id = :id`.
4. If someone is logged in: their own existing review for this album
   (`my_review`) and whether they've favourited it (`is_favourited`),
   both `null`/`false` for a logged-out visitor.

## The star rating **display** vs. the star **picker**

Two different components, both explained in
[02-vue-basics.md](02-vue-basics.md):

- `<star-rating :rating="4">`: read-only, used for the average rating
  and every review in the list. Takes a number in, draws filled and
  empty stars, nothing else.
- `<star-picker v-model="myRating">`: clickable, used only in the
  "write a review" form. Emits an event every time a star is clicked,
  which `v-model` turns into two-way binding.

## Submitting a review: add-or-update in one endpoint

`api/review_add.php` doesn't need a separate "edit" endpoint. It looks
for an existing review by this `user_id` and `album_id`, and decides:

```php
if ($existing) {
    // UPDATE that row
} else {
    // INSERT a new one
}
```

This is backed up at the database level too. The `reviews` table has a
`UNIQUE KEY (user_id, album_id)`, so even a bug in this logic couldn't
create a duplicate review (see
[05-security-concepts.md](05-security-concepts.md), point 9).

When `api/album.php` returns `my_review` on page load, `js/album.js`'s
`loadAlbum()` pre-fills the form with it. That's why the button label
switches between **"Submit review"** and **"Update review"**
(`myReviewId` is `null` versus a real id).

## Why the page doesn't reload after submitting

```js
async submitReview() {
    ...
    await fetch('api/review_add.php', { method: 'POST', ... });
    await this.loadAlbum();   // <- re-fetch everything
},
```

Rather than manually patching the reviews array and recalculating the
average in JavaScript, `submitReview()` just calls `loadAlbum()` again
after a successful save. The server recalculates the true average and
returns the full, correct state. Vue's reactivity updates the page
instantly once the new data arrives: no full browser reload, and no risk
of the displayed average drifting out of sync with what's actually in
the database.

## Deleting a review

`api/review_delete.php` is a single, short file. The entire security
model is one line:

```php
$stmt = db()->prepare('DELETE FROM reviews WHERE id = :id AND user_id = :user_id');
```

See [05-security-concepts.md](05-security-concepts.md), point 6, for why
that `AND user_id = :user_id` matters.
