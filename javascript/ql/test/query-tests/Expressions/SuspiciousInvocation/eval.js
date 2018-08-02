function foo() {
    var f;
    eval("f = alert");
    f("Hi"); // OK: initialised by eval
}

function bar() {
    var g;
    g();    // NOT OK, but not currently flagged
    eval("g = alert");
}

function baz() {
    var g;
    function inner(b) {
        if (b) {
            inner(false);
            g();  // OK: initialised by eval below
        } else {
            eval("g = alert");
        }
    }
    inner(true);
}