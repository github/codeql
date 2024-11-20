function test() {
    let x = source();
    sink(x.toWellFormed()); // NOT OK -- Currently not tainted, but should be

    const wellFormedX = x.toWellFormed();
    sink(wellFormedX); // NOT OK -- Currently not tainted, but should be

    const concatWellFormedX = "/" + wellFormedX + "!";
    sink(concatWellFormedX); // NOT OK -- Currently not tainted, but should be

    sink(source().toWellFormed()); // NOT OK -- Currently not tainted, but should be
}
