function test() {
    var foo = source();

    const arrify = require("arrify");
    sink(arrify(foo)); // NOT OK

    const arrayIfy = require("array-ify");
    sink(arrayIfy(foo)); // NOT OK

    const union = require("array-union");
    sink(union(["bla"], foo)); // NOT OK

    const flat = require("arr-flatten");
    sink(flat(foo)); // NOT OK

    let res = foo.reduce((prev, current) => {
        return prev + '<b>' + current + '</b>';
    }, '');
    sink(res); // NOT OK
}
