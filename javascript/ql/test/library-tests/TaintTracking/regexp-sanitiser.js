function foo() {
    const taint = source();
    if (/^asd[\s\S]*$/.test(taint)) {
        sink(taint); // NOT OK
    }
}
