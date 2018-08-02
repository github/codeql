'use strict'; // OK
'use struct'; // OK (flagged by UnknownDirective.ql)
23; // NOT OK
void(23); // OK
23, foo(); // NOT OK
foo(23, 42); // OK
foo((23, bar())); // NOT OK
foo((bar(), 23)); // OK
1,f(); // NOT OK

// OK
/**
 * @type {function(int) : string}
 */
String.prototype.slice;

// OK
/** @typedef {(string|number)} */
goog.NumberLike;

// NOT OK
/** Useless */
x;

// OK (magic DOM property)
elt.clientTop;

// OK (xUnit fixture)
[Fixture]
function tst() {}

// OK: bad style, but most likely intentional
(0, o.m)();
(0, o["m"])();

function tst() {
  // OK: bad style, but most likely intentional
  (0, eval)("42");
}

function f() {
    var x;
    "foo"; // NOT OK
}

try {
  doSomethingDangerous();
} catch(e) {
  new Error("Told you so"); // NOT OK
  new SyntaxError("Why didn't you listen to me?"); // NOT OK
  new Error(computeSnarkyMessage(e)); // NOT OK
  new UnknownError(); // OK
}
