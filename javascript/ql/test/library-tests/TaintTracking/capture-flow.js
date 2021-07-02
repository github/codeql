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

sink(outerMost()); // NOT OK - but missed

function confuse(x) {
    let captured;
    function f() {
        captured = x;
    }
    f();
    return captured;
}

sink(confuse('safe')); // OK - but incorrectly flagged
sink(confuse(source())); // NOT OK
