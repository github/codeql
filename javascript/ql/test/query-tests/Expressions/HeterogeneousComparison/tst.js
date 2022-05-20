// NOT OK
if (typeof window !== undefined)
  console.log("browser");

// OK
if (typeof window === "undefined")
  console.log("not a browser");

// NOT OK
if ("Hello, world".indexOf("Hello" >= 0))
  console.log("It's in there.");

// OK
true < 1;

// OK
undefined == null;

// NOT OK
null == 0;

// NOT OK
switch ("hi") {
case 42:
}

// NOT OK
Object.toString() + "!" == undefined;

// NOT OK
(+f() || !g() || (h() + k())) == undefined;

// NOT OK
if (!Module['load'] == 'undefined') {
}

function f(x) {
  return true;
  // OK
  return x === 42;
}

function g() {
  var number = 0; // number
  // OK
  number == "0";
  // NO OK
  number == "zero";
}

// NOT OK
0 < (Math.random() > 0.5 ? void 0 : [1, 2]);

// OK
'100' < 1000;

// OK (fvsvo "OK")
100 > '';

// OK
new Date('foo') == 'Invalid Date';

// OK
new String('bar') == 'bar';

// OK
({ valueOf: () => true } == true);

// OK
({ valueOf: () => 42 } == 42);

// OK
({ valueOf: () => 'hi' } == 'hi');

// OK
({ valueOf: () => null } == null);

// NOT OK, but not currently flagged since we conservatively
// assume that `new Date(123)` could return any object, not necessarily a Date
new Date(123) == 123

function f(x1, x2, x3, x4, x5, x6){
    typeof x1 === 'object' && x1 !== null; // OK

    if (!x2) {
        x2 = new Error();
    }
    typeof x2 === 'object' && x2 !== null; // NOT OK: x2 cannot be null here

    if (x3) {
        typeof x3 === 'object' && x3 !== null; // NOT OK: x3 cannot be null here
    }

    if (!x4) {
        typeof x4 === 'object' && x4 !== null; // OK
    }

    if (!x5) {
        x5 = new Error();
    }
    x5 !== null; // NOT OK: x2 cannot be null here

    if (x6) {
        x6 !== null; // NOT OK: x3 cannot be null here
    }
}

function g() {
    var o = {};
    o < "def"; // NOT OK

    var p = { toString() { return "abc"; } };
    p < "def"; // OK

    function A() {}
    var a = new A();
    a < "def"; // NOT OK

    function B() {};
    B.prototype = p;
    var b = new B();
    b < "def"; // OK

    function C() {
      this.valueOf = function() { return 42; };
    }
    var c = new C();
    c != 23; // OK

    null.valueOf = function() { return 42; };
    null == 42; // NOT OK

    true.valueOf = function() { return "foo" };
    true != "bar"; // NOT OK
}


function h() {
    var a = 42;
    var b = "42";

    a === "42"; // NOT OK
    42 === b // NOT OK
    a === b; // NOT OK
}

function i() {
    "foo" === undefined
    undefined === "foo" // NOT OK
    var NaN = 0; // trick analysis to consider warning about NaN, for the purpose of testing pretty printing
    NaN === "foo" // NOT OK
    var Infinity = 0; // trick analysis to consider warning about Infinity, for the purpose of testing pretty printing
    Infinity === "foo" // NOT OK
}

function k() {
    // tests for pretty printing of many types

    var t1 = 42;
    t1 !== null; // NOT OK
    null !== t1; // NOT OK

    var t2 = unknown? t1: "foo";
    t2 !== null; // NOT OK
    null !== t2; // NOT OK

    var t3 = unknown? t2: undefined;
    t3 !== null; // NOT OK
    null !== t3; // NOT OK

    var t4 = unknown? t3: true;
    t4 !== null; // NOT OK
    null !== t4; // NOT OK

    var t5 = unknown? t4: function(){};
    t5 !== null; // NOT OK
    null !== t5; // NOT OK

    var t6 = unknown? t5: /t/;
    t6 !== null; // NOT OK
    null !== t6; // NOT OK

    var t7 = unknown? t6: {};
    t7 !== null; // NOT OK
    null !== t7; // NOT OK

    var t8 = unknown? t8: new Symbol();
    t8 !== null; // NOT OK
    null !== t8; // NOT OK

}

function l() {
    // more tests for pretty printing of many types

    var t2 = unknown? function(){}: /t/;
    var t3 = unknown? t2: {}

    var t4 = unknown? 42: unknown? "foo": unknown? undefined: true;
    var t5 = unknown? t4: null

    t2 !== t4; // NOT OK
    t4 !== t2; // NOT OK
    t3 !== t4; // NOT OK
    t4 !== t3; // NOT OK

    t2 !== t5; // NOT OK
    t5 !== t2; // NOT OK
    t3 !== t5; // NOT OK
    t5 !== t3; // NOT OK
}

1n == 1; // OK

(function tooGeneralLocalFunctions(){
    function f1(x) {
        if (x === "foo") { // OK, whitelisted

        }
    }
    f1(undefined);

    function f2(x, y) {
        var xy = o.q? x: y;
        if (xy === "foo") { // NOT OK (not whitelisted like above)

        }
    }
    f2(undefined, undefined);
})();

function f(...x) {
    x === 42
};
