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

  try {
    gen4();
  } catch (e) {
    sink(e); // OK - exception is only thrown upon iteration
  }

  const iterator = gen4();
  try {
    for (let v of iterator) {
      sink(v); // OK
    }
  } catch (e) {
    sink(e); // NOT OK
  }
  try {
    Array.from(iterator);
  } catch (e) {
    sink(e); // NOT OK
  }

  function *delegating() {
    yield* delegate();
  }

  function *delegate() {
    yield source;
  }

  Array.from(delegating()).forEach(x => sink(x)); // NOT OK

  function *delegating2() {
    yield* returnsTaint();
  }

  function returnsTaint() {
    return source;
  }

  Array.from(delegating2()).forEach(x => sink(x)); // OK
});
