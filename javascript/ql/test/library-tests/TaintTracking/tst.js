function test() {
    let x = source();

    sink(x); // NOT OK
    sink("/" + x + "!"); // NOT OK

    sink(x == null); // OK
    sink(x == undefined); // OK
    sink(x == 1); // OK
    sink(x === 1); // OK
    sink(undefined == x); // OK
    sink(x === x); // OK

    sink(x.sort()); // NOT OK

    var a = [];
    sink(a); // NOT OK (flow-insensitive treatment of `a`)
    a.push(x);
    sink(a); // NOT OK

    var b = [];
    b.unshift(x);
    sink(b); // NOT OK

    sink(x.pop()); // NOT OK
    sink(x.shift()); // NOT OK
    sink(x.slice()); // NOT OK
    sink(x.splice()); // NOT OK

    sink(Array.from(x)); // NOT OK

    x.map((elt, i, ary) => {
        sink(elt); // NOT OK
        sink(i); // OK
        sink(ary); // NOT OK
    });

    x.forEach((elt, i, ary) => {
        sink(elt); // NOT OK
        sink(i); // OK
        sink(ary); // NOT OK
    });

    sink(innocent.map(() => x)); // NOT OK
    sink(x.map(x2 => x2)); // NOT OK

    sink(Buffer.from(x, 'hex')); // NOT OK
    sink(new Buffer(x));         // NOT OK
}
