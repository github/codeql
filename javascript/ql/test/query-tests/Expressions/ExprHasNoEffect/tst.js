'use strict';
'use struct'; // OK - flagged by UnknownDirective.ql
23; // $ Alert
void(23);
23, foo(); // $ Alert
foo(23, 42);
foo((23, bar())); // $ Alert
foo((bar(), 23));
1,f(); // $ Alert


/**
 * @type {function(int) : string}
 */
String.prototype.slice;


/** @typedef {(string|number)} */
goog.NumberLike;

/** Useless */
x; // $ Alert

// OK - magic DOM property
elt.clientTop;

// OK - xUnit fixture
[Fixture]
function tst() {}

// OK - bad style, but most likely intentional
(0, o.m)();
(0, o["m"])();

function tst() {
  // OK - bad style, but most likely intentional
  (0, eval)("42");
}

function f() {
    var x;
    "foo"; // $ Alert
}

try {
  doSomethingDangerous();
} catch(e) {
  new Error("Told you so"); // $ Alert
  new SyntaxError("Why didn't you listen to me?"); // $ Alert
  new Error(computeSnarkyMessage(e)); // $ Alert
  new UnknownError();
}

function g() {
	var o = {};

	Object.defineProperty(o, "trivialGetter1", { get: function(){} });
	o.trivialGetter1;

	Object.defineProperty(o, "trivialNonGetter1", "foo");
	o.trivialNonGetter1; // $ Alert

	var getterDef1 = { get: function(){} };
	Object.defineProperty(o, "nonTrivialGetter1", getterDef1);
	o.nonTrivialGetter1;

	var getterDef2 = { };
	unknownPrepareGetter(getterDef2);
	Object.defineProperty(o, "nonTrivialNonGetter1", getterDef2);
	o.nonTrivialNonGetter1;

	Object.defineProperty(o, "nonTrivialGetter2", unknownGetterDef());
	o.nonTrivialGetter2;
	
	(o: empty);

	testSomeCondition() ? o : // $ Alert
		doSomethingDangerous();

	consume(testSomeCondition() ? o :
		doSomethingDangerous());

	("release" === isRelease() ? warning() : null);
	"release" === isRelease() ? warning() : null;
	"release" === isRelease() ? warning() : 0;
	"release" === isRelease() ? warning() : undefined;
};
