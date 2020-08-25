(function () {
  var source = "source";
  sink(source); // NOT OK

  function *gen1() {
    yield source;
  }
  for (const x of gen1()) {
    sink(x); // NOT OK
  }

  function *gen2() {
    yield "safe";
    return source;
  }
  sink(gen2()); // OK

  Array.from(gen1()).forEach(x => sink(x)); // NOT OK

  function gen3() {
    yield source;
  }
  Array.from(gen3()).forEach(x => sink(x)); // NOT OK

  function *gen4() {
    throw source;
  }
  try {
    Array.from(gen4());
  } catch (e) {
    sink(e); // NOT OK
  }
});
