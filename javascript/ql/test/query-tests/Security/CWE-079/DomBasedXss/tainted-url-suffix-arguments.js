import 'dummy';

function foo(x, y, z) {
    arguments; // ensure 'arguments' are used
    document.writeln(x); // OK [INCONSISTENCY]
    document.writeln(y); // NOT OK
    document.writeln(z); // OK [INCONSISTENCY]
}

function bar() {
    const url = window.location.href;
    foo('safe', url, 'safe');
}
