import 'dummy';

function f(x) {
    let captured;
    function inner() { captured; captured = "sdf"; }

    captured = [source(), "safe", x];
    sink(captured); // NOT OK - implicit read of ArrayElement
    g.apply(undefined, captured); // with use-use flow the output of an implicit read might flow here

    return captured;
}

function g(x, y) {
    sink(x); // NOT OK
    sink(y); // OK
}
