exports.foo = 23;
exports.bar = 42;
exports.baz = 56;
exports.alert = 72;

/*global bar*/
bar();

baz = function() {};
baz();

alert();

exports.isNaN = isNaN
              || function(x) { return x !== x; };

exports.someGlobal = 100;
someGlobal();

window.otherGlobal = function() {};
exports.otherGlobal = otherGlobal;
otherGlobal();
