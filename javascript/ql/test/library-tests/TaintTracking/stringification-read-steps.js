import 'dummy';

function makeObject() {
    return {
        foo: {
            bar: {
                baz: source()
            }
        }
    };
}

function test() {
    const object = makeObject();

    sink(object); // OK
    sink(JSON.stringify(object)); // NOT OK
    sink(object); // OK
}

function testCapture() {
    const object = makeObject();

    sink(object); // OK
    sink(JSON.stringify(object)); // NOT OK
    sink(object); // OK - use-use flow should not see the effects of the implicit read in JSON.stringify

    function capture() {
        object;
    }
}
