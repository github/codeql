test("flow through direct assignment", function() {
    sink(source('t1.1')); // $ hasValueFlow=t1.1

    var x = source('t1.2');
    sink(x); // $ hasValueFlow=t1.2

    var y;
    sink(y);
    y = source('t1.3');
    sink(y); // $ hasValueFlow=t1.3

    var z = source('t1.4');
    var w = z;
    sink(w); // $ hasValueFlow=t1.4
});

test("flow in and out of function", function() {
    function foo(x) {
        return x;
    }

    var y = foo(source('t2.0'));
    sink(y); // $ hasValueFlow=t2.0
});

test("flow into function body", function() {
    function foo(x) {
        sink(x); // $ hasValueFlow=t2.0a
    }

    foo(source('t2.0a'));
});

test("flow out of nested function body", function() {
    function foo() {
        return source('t2.0b');
    }

    var y = foo();
    sink(y); // $ hasValueFlow=t2.0b
});

test("flow through captured variables", function() {
    var x = source('t2.1');

    function inner() {
        sink(x); // $ hasValueFlow=t2.1
    }

    inner();
});

test("flow through captured variable with reassignment", function() {
    var x;
    x = source('t2.2');

    function inner() {
        sink(x); // $ hasValueFlow=t2.2
    }

    inner();
});

test("flow through captured variable assigned in inner function", function() {
    var x;

    function assign() {
        x = source('t2.3');
    }

    assign();
    sink(x); // $ hasValueFlow=t2.3
});

test("flow through multiple levels of captured variables", function() {
    var x = source('t2.4');

    function mid() {
        function inner() {
            sink(x); // $ hasValueFlow=t2.4
        }
        inner();
    }

    mid();
});

test("flow through captured variable with intermediate variable", function() {
    var x = source('t2.5');

    function inner() {
        var y = x;
        sink(y); // $ hasValueFlow=t2.5
    }

    inner();
});
