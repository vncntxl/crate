# Vue 3 Basics (loaded from a CDN)

Every page that needs interactivity has a line like this near the bottom:

```html
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="js/app.js"></script>
```

The first line downloads Vue itself from a public server (a "CDN," or
content delivery network). It's exactly like linking a font or an icon
library, except what's being linked is a JavaScript framework. There is
no `npm install`, no build step, no compiling. The browser just
downloads a `.js` file and runs it, the same way it would run any script
you wrote yourself.

Because there's no build step, there's also no `import`/`export` between
files. Every page's JS file (`app.js`, `album.js`, `account.js`, and so
on) is a completely separate, self-contained script. If two pages both
need a small piece, like the read-only star display, that piece gets
written twice, once in each file, rather than shared through an import.
That's a real trade-off of this simpler setup, and it's fine to say so
in the viva: a build tool would let us share code between files, but a
project this size doesn't need one.

## `createApp` and `.mount`

```js
const { createApp } = Vue;

createApp({
    data() { return { albums: [] }; },
    mounted() { /* runs once, right after mounting */ },
    methods: { /* functions the template can call */ },
}).mount('#app');
```

- `createApp({...})` builds a Vue **application** out of a plain
  JavaScript object. Think of this object as a recipe: here's what this
  page needs to remember (`data`), and here's what it can do
  (`methods`).
- `.mount('#app')` is the step where Vue actually takes control. It
  finds the element with `id="app"` in the HTML (every page has exactly
  one, e.g. `<div id="app">` in `index.php`) and takes over everything
  inside it. From that point on, Vue watches the data and automatically
  redraws any part of that HTML that depends on it, whenever it changes.
  You never write code that manually finds an element and changes its
  text or its class; you just change the data, and Vue does the
  redrawing.

## `data()`: the page's memory

```js
data() {
    return {
        albums: [],
        searchTerm: '',
        loading: true,
    };
},
```

Every property returned from `data()` is **reactive**: Vue is watching
it. If `this.searchTerm` changes, any part of the template that uses
`searchTerm` re-renders automatically. This is the core trick that makes
Vue feel "alive" compared to plain HTML. You never say "now go update
the page." You just update the data, and the page catches up on its own.

## Template syntax used throughout Crate

- **`{{ album.title }}`**: prints a value into the page as text.
- **`v-for="album in albums"`**: repeats an element once per item in an
  array. This is how the album grid in `index.php` turns an array of 8
  albums into 8 `<a class="album-card">` elements.
- **`v-if` / `v-else-if` / `v-else`**: shows or hides a whole element
  based on a condition, e.g. showing "Loading..." while `loading` is
  true, then swapping to the actual grid once it's false.
- **`v-model="searchTerm"`**: two-way binds an `<input>` to a data
  property. Typing in the box updates `searchTerm`, and changing
  `searchTerm` in code would update the box. It's shorthand for
  listening to the input's `input` event and setting the value yourself.
- **`:href="'album.php?id=' + album.id"`**: the colon is shorthand for
  `v-bind`. It means the value of this HTML attribute comes from a
  JavaScript expression, as opposed to a plain `href="..."` which would
  just be a literal string.
- **`:class="{ active: genre === activeGenre }"`**: class binding. Vue
  adds the class `active` to the element only when the expression
  (`genre === activeGenre`) is true. This is how the genre chips and
  heart buttons visually show which one is selected or favourited,
  without any manual `classList.add`/`remove` code.
- **`@click="filterByGenre(genre)"`**: the `@` is shorthand for `v-on`.
  It wires up an event listener, here calling a method when the button
  is clicked.
- **`@click.stop.prevent="toggleFavourite(album.id)"`**: modifiers
  chained onto an event. `.prevent` stops the browser's default action
  (e.g. stops a link from actually navigating), and `.stop` stops the
  click from also triggering a listener on a parent element. Both are
  needed on the heart button in `index.php`, because the heart button
  sits *inside* the album card's `<a>` link. Without `.stop.prevent`,
  clicking the heart would also navigate to the album page.

## Components: reusable pieces of UI

A **component** is a small, named, reusable chunk of template and logic.
Crate defines two.

```js
const StarRating = {
    props: { rating: { type: Number, required: true } },
    template: `
        <span class="star-rating">
            <span v-for="n in 5" :key="n" :class="{ filled: n <= Math.round(rating) }">★</span>
        </span>
    `,
};
```

- **`props`** are how data flows *into* a component from whoever uses
  it, like a function's parameters. `<star-rating :rating="4"></star-rating>`
  passes the number 4 in as the `rating` prop.
- This component is **read-only**: it just displays stars, and can't be
  clicked. It's used on the album page and the account page, to show an
  existing rating.

The second component, `StarPicker`, is interactive:

```js
const StarPicker = {
    props: { modelValue: { type: Number, default: 0 } },
    emits: ['update:modelValue'],
    template: `
        <span class="star-picker">
            <button v-for="n in 5" :key="n" type="button"
                :class="{ filled: n <= modelValue }"
                @click="$emit('update:modelValue', n)">★</button>
        </span>
    `,
};
```

- **`emits`** declares an event this component can send back *out* to
  whoever is using it, like a function's return value, but event-based.
- Naming the prop `modelValue` and the event `update:modelValue` is a
  Vue convention, not an accident. It's exactly what lets someone write
  `<star-picker v-model="myRating"></star-picker>` on the outside and get
  free two-way binding, the same way `v-model` works on a plain
  `<input>`. Vue is really just doing `:model-value="myRating"` plus
  `@update:model-value="myRating = $event"` behind the scenes.

Both components are registered onto the app right before mounting:

```js
createApp({ ... })
    .component('star-rating', StarRating)
    .component('star-picker', StarPicker)
    .mount('#app');
```

`.component('star-rating', StarRating)` is what makes the tag
`<star-rating>` usable inside this app's templates. Without registering
it, Vue would have no idea what that custom tag means.
