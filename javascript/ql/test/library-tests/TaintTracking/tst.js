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
}
