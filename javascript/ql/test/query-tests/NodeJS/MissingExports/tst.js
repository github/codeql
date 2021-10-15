exports.foo = 23;
exports.bar = 42;
exports.baz = 56;
exports.alert = 72;

/*global bar*/
bar(); // OK

baz = function() {};
baz(); // OK

alert(); // OK

exports.isNaN = isNaN // OK
              || function(x) { return x !== x; };

exports.someGlobal = 100;
someGlobal(); // OK

window.otherGlobal = function() {};
exports.otherGlobal = otherGlobal;
otherGlobal(); // OK
