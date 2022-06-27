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

function g() {
	var o = {};

	Object.defineProperty(o, "trivialGetter1", { get: function(){} });
	o.trivialGetter1; // OK

	Object.defineProperty(o, "trivialNonGetter1", "foo");
	o.trivialNonGetter1; // NOT OK

	var getterDef1 = { get: function(){} };
	Object.defineProperty(o, "nonTrivialGetter1", getterDef1);
	o.nonTrivialGetter1; // OK

	var getterDef2 = { };
	unknownPrepareGetter(getterDef2);
	Object.defineProperty(o, "nonTrivialNonGetter1", getterDef2);
	o.nonTrivialNonGetter1; // OK

	Object.defineProperty(o, "nonTrivialGetter2", unknownGetterDef());
	o.nonTrivialGetter2; // OK
	
	(o: empty); // OK

	testSomeCondition() ? o : // NOT OK
		doSomethingDangerous();

	consume(testSomeCondition() ? o : // OK
		doSomethingDangerous());
};
