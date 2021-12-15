(function (x) {
  var y = x;
})(42);

(function (x) {
  each(arguments, console.log); // `arguments` escapes
  var y = x;
})(42);

(function (x) {
  'use strict';
  each(arguments, console.log);
  var y = x;
})(42);

(function (x, i) {
  arguments[i] = 'hi'; // possible mutation of `x` through `arguments`
  var y = x;
})(42);


(function (x, i) {
  arguments.length = 0;
  var y = x;
  // we currently infer an indefinite value for `x`, since
  // our analysis for IIFE parameters bails if there is a use
  // of `arguments` of a non-strict IIFE
})(42);

(function (x, i) {
  console.log(arguments[i]);
  var y = x; // see above: conservative handling of IIFEs
})(42);
