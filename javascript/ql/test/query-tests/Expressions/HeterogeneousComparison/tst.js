if (typeof window !== undefined) // $ Alert
  console.log("browser");


if (typeof window === "undefined")
  console.log("not a browser");

if ("Hello, world".indexOf("Hello" >= 0)) // $ Alert
  console.log("It's in there.");


true < 1;


undefined == null;

null == 0; // $ Alert

switch ("hi") {
case 42: // $ Alert
}

Object.toString() + "!" == undefined; // $ Alert

(+f() || !g() || (h() + k())) == undefined; // $ Alert

if (!Module['load'] == 'undefined') { // $ Alert
}

function f(x) {
  return true;

  return x === 42;
}

function g() {
  var number = 0; // number

  number == "0";

  number == "zero"; // $ Alert
}

0 < (Math.random() > 0.5 ? void 0 : [1, 2]); // $ Alert


'100' < 1000;

// OK - fvsvo "OK"
100 > '';


new Date('foo') == 'Invalid Date';


new String('bar') == 'bar';


({ valueOf: () => true } == true);


({ valueOf: () => 42 } == 42);


({ valueOf: () => 'hi' } == 'hi');


({ valueOf: () => null } == null);

new Date(123) == 123; // $ MISSING: Alert - we conservatively assume that `new Date(123)` could return any object, not necessarily a Date

function f(x1, x2, x3, x4, x5, x6){
    typeof x1 === 'object' && x1 !== null;

    if (!x2) {
        x2 = new Error();
    }
    typeof x2 === 'object' && x2 !== null; // $ Alert - x2 cannot be null here

    if (x3) {
        typeof x3 === 'object' && x3 !== null; // $ Alert - x3 cannot be null here
    }

    if (!x4) {
        typeof x4 === 'object' && x4 !== null;
    }

    if (!x5) {
        x5 = new Error();
    }
    x5 !== null; // $ Alert - x2 cannot be null here

    if (x6) {
        x6 !== null; // $ Alert - x3 cannot be null here
    }
}

function g() {
    var o = {};
    o < "def"; // $ Alert

    var p = { toString() { return "abc"; } };
    p < "def";

    function A() {}
    var a = new A();
    a < "def"; // $ Alert

    function B() {};
    B.prototype = p;
    var b = new B();
    b < "def";

    function C() {
      this.valueOf = function() { return 42; };
    }
    var c = new C();
    c != 23;

    null.valueOf = function() { return 42; };
    null == 42; // $ Alert

    true.valueOf = function() { return "foo" };
    true != "bar"; // $ Alert
}


function h() {
    var a = 42;
    var b = "42";

    a === "42"; // $ Alert
    42 === b // $ Alert
    a === b; // $ Alert
}

function i() {
    "foo" === undefined // $ Alert
    undefined === "foo" // $ Alert
    var NaN = 0; // trick analysis to consider warning about NaN, for the purpose of testing pretty printing
    NaN === "foo" // $ Alert
    var Infinity = 0; // trick analysis to consider warning about Infinity, for the purpose of testing pretty printing
    Infinity === "foo" // $ Alert
}

function k() {
    // tests for pretty printing of many types

    var t1 = 42;
    t1 !== null; // $ Alert
    null !== t1; // $ Alert

    var t2 = unknown? t1: "foo";
    t2 !== null; // $ Alert
    null !== t2; // $ Alert

    var t3 = unknown? t2: undefined;
    t3 !== null; // $ Alert
    null !== t3; // $ Alert

    var t4 = unknown? t3: true;
    t4 !== null; // $ Alert
    null !== t4; // $ Alert

    var t5 = unknown? t4: function(){};
    t5 !== null; // $ Alert
    null !== t5; // $ Alert

    var t6 = unknown? t5: /t/;
    t6 !== null; // $ Alert
    null !== t6; // $ Alert

    var t7 = unknown? t6: {};
    t7 !== null; // $ Alert
    null !== t7; // $ Alert

    var t8 = unknown? t8: new Symbol();
    t8 !== null; // $ Alert
    null !== t8; // $ Alert

}

function l() {
    // more tests for pretty printing of many types

    var t2 = unknown? function(){}: /t/;
    var t3 = unknown? t2: {}

    var t4 = unknown? 42: unknown? "foo": unknown? undefined: true;
    var t5 = unknown? t4: null

    t2 !== t4; // $ Alert
    t4 !== t2; // $ Alert
    t3 !== t4; // $ Alert
    t4 !== t3; // $ Alert

    t2 !== t5; // $ Alert
    t5 !== t2; // $ Alert
    t3 !== t5; // $ Alert
    t5 !== t3; // $ Alert
}

1n == 1;

(function tooGeneralLocalFunctions(){
    function f1(x) {
        if (x === "foo") { // OK - whitelisted

        }
    }
    f1(undefined);

    function f2(x, y) {
        var xy = o.q? x: y;
        if (xy === "foo") { // $ Alert - not whitelisted like above

        }
    }
    f2(undefined, undefined);
})();

function f(...x) {
    x === 42 // $ Alert
};
