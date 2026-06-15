function m1() {
  const flowThrough = mkSummary("Argument[0]", "ReturnValue");
  sink(flowThrough(source())); // NOT OK
  sink(flowThrough(source() + "x")); // OK - we are not tracking taint in this test
  sink(flowThrough("x")); // OK
}

function m2() {
  const flowIntoProp = mkSummary("Argument[0]", "ReturnValue.Member[prop]");
  sink(flowIntoProp(source()).prop); // NOT OK
  sink(flowIntoProp(source()).prop2); // OK
  sink(flowIntoProp(source())); // OK
}

function m3() {
  const flowOutOfProp = mkSummary("Argument[0].Member[prop]", "ReturnValue");
  sink(flowOutOfProp({ prop: source() })); // NOT OK
  sink(flowOutOfProp({ prop2: source() })); // OK
  sink(flowOutOfProp(source())); // OK

  const obj = {};
  obj.prop = source();
  sink(flowOutOfProp(obj)); // NOT OK
  sink(obj); // OK
  sink(obj.prop); // NOT OK
}

function m4() {
  const flowIntoArrayElement = mkSummary("Argument[0]", "ReturnValue.ArrayElement");
  sink(flowIntoArrayElement(source()).pop()); // NOT OK
  sink(flowIntoArrayElement(source())[0]); // NOT OK
  sink(flowIntoArrayElement(source())[Math.random()]); // NOT OK
  sink(flowIntoArrayElement(source()).prop); // OK
}

function m5() {
  const flowOutOfInnerCallback = mkSummary("Argument[0].Parameter[0].Argument[0]", "ReturnValue");
  sink(flowOutOfInnerCallback(cb => { cb(source()); })); // NOT OK [INCONSISTENCY]
}

async function m6() {
  const flowOutOfPromise = mkSummary("Argument[0].Awaited", "ReturnValue");
  const flowIntoPromise = mkSummary("Argument[0]", "ReturnValue.Awaited");

  sink(flowOutOfPromise(flowIntoPromise(source()))); // NOT OK (although the synchronous flow is technically not possible)

  let data = { prop: source() };
  sink(flowOutOfPromise(flowIntoPromise(data)).prop); // NOT OK
  sink(flowOutOfPromise(flowIntoPromise(flowIntoPromise(data))).prop); // NOT OK
  sink(flowOutOfPromise(flowOutOfPromise(flowIntoPromise(data))).prop); // NOT OK
  sink(flowOutOfPromise(data).prop); // NOT OK - because Awaited allows pass-through of a non-promise value
  sink(flowIntoPromise(data).prop); // OK - promise object does not have the 'prop' property

  sink(flowOutOfPromise(Promise.resolve(source()))); // NOT OK
  sink(flowOutOfPromise(Promise.resolve("safe").then(x => source()))); // NOT OK
  sink(flowOutOfPromise(Promise.resolve("safe").then(x => "safe"))); // OK
  sink(flowOutOfPromise(Promise.resolve(source()).then(x => "safe"))); // OK

  sink(flowOutOfPromise(Promise.reject(source()))); // OK
  sink(flowOutOfPromise(Promise.reject(source()).then(x => "safe", y => y))); // NOT OK
  sink(flowOutOfPromise(Promise.reject(source()).then(x => x, y => "safe"))); // OK
  sink(flowOutOfPromise(Promise.reject("safe").then(x => x, y => y))); // OK

  sink(flowOutOfPromise(Promise.reject(source()))); // OK
  sink(flowOutOfPromise(Promise.reject(source()).catch(err => err))); // NOT OK
  sink(flowOutOfPromise(Promise.reject(source()).catch(err => "safe"))); // OK
  sink(flowOutOfPromise(Promise.reject("safe").catch(err => err))); // OK

  sink(flowOutOfPromise(Promise.reject(source()).then(x => "safe").catch(err => err))); // NOT OK

  sink(flowOutOfPromise(Promise.reject(source()).finally(() => "safe").catch(err => err))); // NOT OK
  sink(flowOutOfPromise(Promise.resolve(source()).finally(() => "safe").then(err => err))); // NOT OK
  sink(flowOutOfPromise(Promise.reject("safe").finally(() => { throw source() }).catch(err => err))); // NOT OK

  Promise.resolve("safe")
    .then(x => { throw source(); })
    .catch(err => {
      sink(err); // NOT OK
    });

  Promise.resolve("safe")
    .then(x => { throw source(); })
    .then(x => "safe")
    .catch(err => {
      sink(err); // NOT OK
    });

  sink(await flowIntoPromise(source())); // NOT OK
  flowIntoPromise(source()).then(value => sink(value)); // NOT OK
  sink(await flowIntoPromise(flowIntoPromise(source()))); // NOT OK

  async function makePromise() {
    return source();
  }
  sink(flowOutOfPromise(makePromise())); // NOT OK

  let taintedPromise = new Promise((resolve, reject) => resolve(source()));
  sink(flowOutOfPromise(taintedPromise)); // NOT OK

  new Promise((resolve, reject) => resolve(source())).then(x => sink(x)); // NOT OK
  new Promise((resolve, reject) => resolve(source())).catch(err => sink(err)); // OK
  new Promise((resolve, reject) => reject(source())).then(x => sink(x)); // OK
  new Promise((resolve, reject) => reject(source())).catch(err => sink(err)); // NOT OK

  Promise.all([
    flowIntoPromise(source()),
    source(),
    "safe"
  ]).then(([x1, x2, x3]) => {
    sink(x1); // NOT OK
    sink(x2); // NOT OK
    sink(x3); // OK
  });
}

function m8() {
  const flowOutOfCallback = mkSummary("Argument[0].ReturnValue", "ReturnValue");

  sink(flowOutOfCallback(() => source())); // NOT OK
  sink(flowOutOfCallback((source))); // OK

  function sourceCallback() {
    return source();
  }
  sink(flowOutOfCallback(sourceCallback)); // NOT OK
}

function m9() {
  const flowIntoCallback = mkSummary("Argument[0]", "Argument[1].Parameter[0]");

  sink(flowIntoCallback(source(), x => sink(x))); // NOT OK
  sink(flowIntoCallback("safe", x => sink(x))); // OK
  sink(flowIntoCallback(source(), x => ignore(x))); // OK
  sink(flowIntoCallback("safe", x => ignore(x))); // OK
}

function m10() {
  const flowThroughCallback = mkSummary([
    ["Argument[0]", "Argument[1].Parameter[0]"],
    ["Argument[1].ReturnValue", "ReturnValue"]
  ]);

  sink(flowThroughCallback(source(), x => x)); // NOT OK
  sink(flowThroughCallback(source(), x => "safe")); // OK
  sink(flowThroughCallback("safe", x => x)); // OK
  sink(flowThroughCallback("safe", x => "safe")); // OK
}

function m11() {
  const flowFromSideEffectOnParameter = mkSummary("Argument[0].Parameter[0].Member[prop]", "ReturnValue");

  let data = flowFromSideEffectOnParameter(param => {
    param.prop = source();
  });
  sink(data); // NOT OK

  function manullyWritten(param) {
    param.prop = source();
  }
  let obj = {};
  manullyWritten(obj);
  sink(obj.prop); // NOT OK
}

async function m13() {
  async function testStoreBack(x) {
    (await x).prop = source();
  }
  const obj = {};
  const promise = Promise.resolve(obj);
  testStoreBack(promise);
  sink(obj.prop); // NOT OK [INCONSISTENCY]
  sink(promise.prop); // OK [INCONSISTENCY]
  sink((await promise).prop); // NOT OK

  const obj2 = {};
  testStoreBack(obj2);
  sink(obj2.prop);; // NOT OK
}

function m14() {
  const flowOutOfAnyArgument = mkSummary("Argument[0..]", "ReturnValue");
  sink(flowOutOfAnyArgument(source())); // NOT OK
  sink(flowOutOfAnyArgument(source(), "safe", "safe")); // NOT OK
  sink(flowOutOfAnyArgument("safe", source(), "safe")); // NOT OK
  sink(flowOutOfAnyArgument("safe", "safe", source())); // NOT OK
  sink(flowOutOfAnyArgument("safe", "safe", "safe")); // OK

  const flowOutOfAnyArgumentExceptFirst = mkSummary("Argument[1..]", "ReturnValue");
  sink(flowOutOfAnyArgumentExceptFirst(source())); // OK
  sink(flowOutOfAnyArgumentExceptFirst(source(), "safe", "safe")); // OK
  sink(flowOutOfAnyArgumentExceptFirst("safe", source(), "safe")); // NOT OK
  sink(flowOutOfAnyArgumentExceptFirst("safe", "safe", source())); // NOT OK
  sink(flowOutOfAnyArgumentExceptFirst("safe", "safe", "safe")); // OK

  const flowIntoAnyParameter = mkSummary("Argument[0]", "Argument[1].Parameter[0..]");
  flowIntoAnyParameter(source(), (x1, x2, x3) => sink(x1)); // NOT OK
  flowIntoAnyParameter(source(), (x1, x2, x3) => sink(x2)); // NOT OK
  flowIntoAnyParameter(source(), (x1, x2, x3) => sink(x3)); // NOT OK

  const flowIntoAnyParameterExceptFirst = mkSummary("Argument[0]", "Argument[1].Parameter[1..]");
  flowIntoAnyParameterExceptFirst(source(), (x1, x2, x3) => sink(x1)); // OK
  flowIntoAnyParameterExceptFirst(source(), (x1, x2, x3) => sink(x2)); // NOT OK
  flowIntoAnyParameterExceptFirst(source(), (x1, x2, x3) => sink(x3)); // NOT OK
}

function m15() {
  const array = [];
  array.push("safe", "safe", source());
  sink(array.pop()); // NOT OK

  const array2 = [];
  array2.push(source());
  array2.push("safe");
  array2.push("safe");
  array2.forEach(x => sink(x)); // NOT OK

  const array3 = [];
  array3.push(...[source()]);
  array3.forEach(x => sink(x)); // NOT OK

  const array4 = [source()];
  array4 = Array.prototype.slice.call(array4);
  sink(array4.pop()); // NOT OK

  [source()].forEach((value, index, array) => { sink(array.pop()) }); // NOT OK
  const array5 = [source()];
  array5.forEach((value, index, array) => { sink(array.pop()) }); // NOT OK
  ["safe"].forEach((value, index, array) => { sink(array.pop()) }); // OK
}

function m16() {
  const array0 = [source(), 'safe', 'safe'];
  sink(array0[0]); // NOT OK
  sink(array0[1]); // OK
  sink(array0[2]); // OK

  const array1 = ['safe', source(), 'safe'];
  sink(array1[0]); // OK
  sink(array1[1]); // NOT OK
  sink(array1[2]); // OK

  const array2 = ['safe', 'safe', source()];
  sink(array2[0]); // OK
  sink(array2[1]); // OK
  sink(array2[2]); // NOT OK
}

function m17() {
  const map = new Map();
  map.set('foo', source());
  map.set('bar', 'safe');

  sink(map.get('foo')); // NOT OK
  sink(map.get('bar')); // OK
  sink(map.get(getUnkown())); // NOT OK

  const map2 = new Map();
  map2.set(getUnkown(), source());
  sink(map2.get('foo')); // NOT OK
  sink(map2.get('bar')); // NOT OK
  sink(map2.get(getUnkown())); // NOT OK

  const map3 = new Map();
  map3.set('foo', source());
  map3.forEach(value => sink(value)); // NOT OK
  for (let [key, value] of map3) {
    sink(value); // NOT OK
  }
}

function m18() {
  const staticParam0 = mkSummary("Argument[0]", "ReturnValue");
  const staticParam1 = mkSummary("Argument[1]", "ReturnValue");
  const dynamicParam0 = mkSummary("Argument[0..]", "ReturnValue");
  const dynamicParam1 = mkSummary("Argument[1..]", "ReturnValue");

  sink(staticParam0(...[source()])); // NOT OK
  sink(staticParam0(...["safe", source()])); // OK
  sink(staticParam0(...[source(), "safe", ])); // NOT OK
  sink(staticParam0("safe", ...[source()])); // OK
  sink(staticParam0(source(), ...["safe"])); // NOT OK

  sink(staticParam1(...[source()])); // OK
  sink(staticParam1(...["safe", source()])); // NOT OK
  sink(staticParam1(...[source(), "safe", ])); // OK
  sink(staticParam1("safe", ...[source()])); // NOT OK
  sink(staticParam1(source(), ...["safe"])); // OK

  sink(dynamicParam0(...[source()])); // NOT OK
  sink(dynamicParam0(...["safe", source()])); // NOT OK
  sink(dynamicParam0(...[source(), "safe", ])); // NOT OK
  sink(dynamicParam0("safe", ...[source()])); // NOT OK
  sink(dynamicParam0(source(), ...["safe"])); // NOT OK

  sink(dynamicParam1(...[source()])); // OK
  sink(dynamicParam1(...["safe", source()])); // NOT OK
  sink(dynamicParam1(...[source(), "safe", ])); // OK
  sink(dynamicParam1("safe", ...[source()])); // NOT OK
  sink(dynamicParam1(source(), ...["safe"])); // OK
}
