import * as dummy from 'dummy';

function sanitizer_id(x) {
    if (really_complicated_reason(x))
        return x;
    return null;
}

function useTaintedValue(x) {
    if (isSafe(x)) {
        sink(x); // OK
        sink(x.foo); // OK
    }

    sink(sanitizer_id(x)); // OK
    sink(sanitizer_id(x.foo)); // OK
    sink(sanitizer_id(x).foo); // OK
}

function useTaintedObject(obj) {
    if (isSafe(obj)) {
        sink(obj); // OK
        sink(obj.foo); // NOT OK
    }

    sink(sanitizer_id(obj)); // OK
    sink(sanitizer_id(obj.foo)); // OK
    sink(sanitizer_id(obj).foo); // NOT OK
}

function test() {
    useTaintedValue(source());
    useTaintedValue(null);

    useTaintedObject({ foo: source() });
    useTaintedObject(null);
}
