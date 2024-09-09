import 'dummy';

function foo(x, y, z) {
    arguments; // ensure 'arguments' are used
    document.writeln(x); // OK
    document.writeln(y); // NOT OK
    document.writeln(z); // OK
}

function bar() {
    const url = window.location.href;
    foo('safe', url, 'safe');
}
