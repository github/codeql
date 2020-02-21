import * as dummy from 'dummy';

function sanitizer_id(x) {
    if (really_complicated_reason(x))
        return x;
    return null;
}

function f(x) {
    if (isSafe(x)) {
        sink(x);
        sink(x.foo); // NOT OK
    }

    sink(sanitizer_id(x)); // OK
    sink(sanitizer_id(x.foo)); // OK
    sink(sanitizer_id(x).foo); // NOT OK
}

function g() {
    f(source()); // OK
    f(null);
    f({foo: source()}); // NOT OK
}
