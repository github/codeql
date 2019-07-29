function test() {
  let taint = source();

  sink(x && taint); // NOT OK
  sink(x && taint.prop); // NOT OK
  sink(taint && x); // OK
  sink(taint && taint.prop); // OK

  sink(x || taint); // NOT OK
  sink(x || taint.prop); // NOT OK
  sink(taint || x); // NOT OK
  sink(taint || taint.prop); // NOT OK

  sink(x ?? taint); // NOT OK
  sink(x ?? taint.prop); // NOT OK
  sink(taint ?? x); // NOT OK
  sink(taint ?? taint.prop); // NOT OK
}

// semmle-extractor-options: --experimental
