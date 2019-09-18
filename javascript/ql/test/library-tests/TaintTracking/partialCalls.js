let R = require('ramda');

function test() {
    let taint = source();

    function safe1(x, y) {
        sink(x); // OK - x is not tainted
    }
    function safe2(x, y) {
        sink(y); // OK - y is not tainted
    }

    safe1.bind(null, "hello", taint)();
    safe2.bind(null, taint, "hello")();

    function unsafe1(x, y) {
        sink(x); // NOT OK - x is tainted
    }
    function unsafe2(x ,y) {
        sink(y); // NOT OK - y is tainted
    }

    unsafe1.bind(null, taint, "hello")();
    unsafe2.bind(null, "hello", taint)();

    function safeprop(x) {
        sink(x.value); // OK - property `value` is not tainted
    }
    function unsafeprop(x) {
        sink(x.value); // NOT OK - property `value` is tainted
    }

    safeprop.bind(null, {value: "hello", somethingElse: taint})();
    unsafeprop.bind(null, {value: taint, somethingElse: "hello"})();

    function id(x) {
        return x;
    }

    sink(id("hello")); // OK
    sink(id(taint));   // NOT OK

    let taintGetter = id.bind(null, taint);
    sink(taintGetter);   // OK - this is a function object
    sink(taintGetter()); // NOT OK - but not currently detected

    function safearray(x) {
        sink(x); // OK
    }
    function unsafearray(x) {
        sink(x); // NOT OK
    }

    let xs = ["hello"];
    let ys = [taint];
    R.partial(safearray, xs)();
    R.partial(unsafearray, ys)();
}
