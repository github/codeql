goog.module('test');

function test(x) {
  addEventListener("click", goog.bind(function(x, event) {}, this, x));
}
