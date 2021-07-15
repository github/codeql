function test() {
    var foo = source();

    const arrify = require("arrify");
    sink(arrify(foo)); // NOT OK

    const arrayIfy = require("array-ify");
    sink(arrayIfy(foo)); // NOT OK
}