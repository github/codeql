let lodash = require('lodash');
let R = require('ramda');

function test(x) {
  addEventListener("click", function(x, event) {}.bind(this, x));
  addEventListener("click", lodash.partial(function(x, event) {}, x));
  addEventListener("click", R.partial(function(x, event) {}, [x]));
  addEventListener("click", angular.bind(this, function(x, event) {}, x));

  function f(x, event) {}
  addEventListener("click", f.bind(this, x));
}
