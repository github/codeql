import 'dummy';

function outerMost() {
    function outer() {
        var captured;
        function f(x) {
            captured = x;
        }
        f(source());

        return captured;
    }

    sink(outer()); // NOT OK

    return outer();
}

sink(outerMost()); // NOT OK

function confuse(x) {
    let captured;
    function f() {
        captured = x;
    }
    f();
    return captured;
}

sink(confuse('safe')); // OK
sink(confuse(source())); // NOT OK

function innerRead(x) {
    let captured = { data: x };
    function read() {
        if (blah()) {}
        captured;
        if (blah()) {}
        return (captured || {}).data;
    }
    function other() {
        captured = {};
    }
    return read();
}

sink(innerRead('safe')); // OK
sink(innerRead(source())); // NOT OK
