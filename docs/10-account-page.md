# Account Page

**Files:** `account.php`, `js/account.js`, `api/my_reviews.php`, `api/account_update.php`, `api/password_change.php` (reuses `api/review_add.php` and `api/review_delete.php` from [07-album-detail-and-reviews.md](07-album-detail-and-reviews.md))

This page does three unrelated jobs at once, which is why `js/account.js`'s
`data()` is split into three clearly-labelled groups (profile form,
password form, reviews list) even though they all live in one Vue app.

## Pre-filling the profile form without an extra request

Same `data-*` trick as the album id (see
[07-album-detail-and-reviews.md](07-album-detail-and-reviews.md)):

```php
<div id="app" data-user-name="<?= e($loggedInUser['name']) ?>" data-user-email="<?= e($loggedInUser['email']) ?>">
```

```js
data() {
    const el = document.getElementById('app');
    return { profileName: el.dataset.userName, profileEmail: el.dataset.userEmail, ... };
},
```

PHP already knows who's logged in (it just ran `require_login()`), so
there's no reason to make a separate `fetch()` just to ask "who am I?"
before the form can render with real values in it.

## Changing your password requires the *current* one

```php
if (!$user || !password_verify($currentPassword, $user['password'])) {
    // reject - "Current password is incorrect."
}
```

Without this check, anyone who found an already-logged-in browser (a
shared computer, a laptop left unlocked) could lock the real account
owner out just by setting a brand new password. Requiring the current
password first means changing it always proves you already knew the old
one.

## Managing your own reviews

`api/my_reviews.php` is filtered to `WHERE reviews.user_id = :user_id`
using the *session's own* id - it's structurally impossible for this
endpoint to return anyone else's reviews, since there's no code path
where a different id could get into that placeholder.

Editing reuses `api/review_add.php` exactly as-is (it already knows how
to update an existing review by `user_id` + `album_id` - see
[07-album-detail-and-reviews.md](07-album-detail-and-reviews.md)).
`account.php`'s template swaps between a **display** view and an
**edit** view for whichever single review is being edited:

```html
<div v-if="editingId !== review.id"> ... normal display ... </div>
<form v-else @submit.prevent="saveEdit(review)"> ... star-picker + textarea ... </form>
```

`editingId` holds the id of the one review currently being edited (or
`null`), so only that one row swaps to edit mode - every other review in
the list stays in its normal display state.

Deleting reuses `api/review_delete.php` unchanged, with the same
ownership check described in
[05-security-concepts.md](05-security-concepts.md).
