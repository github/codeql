(async function () {
  let source = "source";

  async function async() {
    return source;
  }
  let sink = async(); // OK - wrapped in a promise. (NOT OK for taint-tracking configs)
  let sink2 = await async(); // NOT OK

  function sync() {
    return source;
  }
  let sink3 = sync(); // NOT OK
  let sink4 = await sync(); // NOT OK

  async function throwsAsync() {
    throw source;
  }
  try {
    throwsAsync();
  } catch (e) {
    let sink5 = e; // OK - throwsAsync just returns a promise.
  }
  try {
    await throwsAsync();
  } catch (e) {
    let sink6 = e; // NOT OK
  }

  function throws() {
    throw source;
  }
  try {
    throws();
  } catch (e) {
    let sink5 = e; // NOT OK
  }
  try {
    await throws();
  } catch (e) {
    let sink6 = e; // NOT OK
  }

  function syncTest() {
    function pack(x) {
      return {
        x: x
      }
    };
    function unpack(x) {
      return x.x;
    }

    var sink7 = unpack(pack(source)); // NOT OK
  }

  function asyncTest() {
    async function pack(x) {
      return {
        x: x
      }
    };
    function unpack(x) {
      return x.x;
    }

    var sink8 = unpack(pack(source)); // OK
    let sink9 = unpack(await (pack(source))); // NOT OK - but not found
  }
})();

async function props() {
  async function foo(x) {
    return {
      p: x
    };
  }

  let source = "source";
  let sink = (await (foo(source))).p; // NOT OK - this requires the immidiatly awaited storeStep.
  let sink2 = foo("not a source").p;

  async function getP(base) {
    return base.p;
  }

  async function getQ(base) {
    return base.q;
  }

  let o3 = { p: source };
  let sink6 = await (getP(o3)); // NOT OK - this requires the immidiatly awaited loadStep
  let sink7 = await (getQ(o3));

  async function readP() {
    let source = "source";
    var obj = {x: source};
    return obj.x;
  }

  let sink8 = await readP(); // NOT OK
}
