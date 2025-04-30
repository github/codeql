import 'dummy';

function foo(x, y, z) {
    arguments; // ensure 'arguments' are used
    document.writeln(x);
    document.writeln(y); // $ Alert
    document.writeln(z);
}

function bar() {
    const url = window.location.href; // $ Source
    foo('safe', url, 'safe');
}
