import * as dummy from 'dummy';

function blah(obj) {
    obj.prop = obj.prop + "x";
    return obj.prop;
}

function test() {
    sink(blah(source())); // NOT OK

    blah(); // ensure more than one call site exists
}
