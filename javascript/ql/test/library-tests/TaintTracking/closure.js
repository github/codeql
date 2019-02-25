goog.module('test');

let string = goog.require('goog.string');

function test() {
  let taint = source();
  
  sink(string.capitalize(taint)); // NOT OK
  sink(string.trim(taint)); // NOT OK

  sink(string.escapeString(taint)); // OK
}
