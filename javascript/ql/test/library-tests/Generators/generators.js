(function () {
  var source = "source";
  sink(source); // NOT OK

  function *gen1() {
    yield source;
  }
  for (const x of gen1()) {
    sink(x); // NOT OK - but not found yet [INCONSISTENCY]
  }

  function *gen2() {
    yield "safe";
    return source;
  }
  sink(gen2()); // OK
});
