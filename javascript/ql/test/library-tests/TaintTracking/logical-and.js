function test() {
    var taint = source();

    sink("safe" && taint); // NOT OK
    sink(taint && "safe"); // OK
}
