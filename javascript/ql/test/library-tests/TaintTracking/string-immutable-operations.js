function test() {
    let x = source();
    sink(x.toWellFormed()); // NOT OK

    const wellFormedX = x.toWellFormed();
    sink(wellFormedX); // NOT OK

    const concatWellFormedX = "/" + wellFormedX + "!";
    sink(concatWellFormedX); // NOT OK

    sink(source().toWellFormed()); // NOT OK
}
