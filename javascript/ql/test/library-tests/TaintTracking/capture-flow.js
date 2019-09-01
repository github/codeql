function test() {
  let x = source();

  function inner() {
    return x;
  }

  x = source();

  sink(inner()); // NOT OK
}
