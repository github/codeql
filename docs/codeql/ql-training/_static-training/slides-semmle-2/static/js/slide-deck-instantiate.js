
// Polyfill missing APIs (if we need to), then create the slide deck.
// iOS < 5 needs classList, dataset, and window.matchMedia. Modernizr contains
// the last one.
(function() {
  Modernizr.load({
    test: !!document.body.classList && !!document.body.dataset,
    nope: ['js/polyfills/classList.min.js', 'js/polyfills/dataset.min.js'],
    complete: function() {
      window.slidedeck = new SlideDeck();
    }
  });
})();
