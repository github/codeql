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

}
