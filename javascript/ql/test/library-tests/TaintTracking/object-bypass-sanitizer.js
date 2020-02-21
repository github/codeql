import * as dummy from 'dummy';

function f(x) {
    if (isSafe(x)) {
        sink(x);
        sink(x.foo); // NOT OK
    }
}

function g() {
    f(source()); // OK
    f(null);
    f({foo: source()}); // NOT OK
}
