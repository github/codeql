function test(unsafe, safe) {
  try {
    throwRaw2(source());
  } catch (e) {
    sink(e); // NOT OK
  }

  try {
    throwRaw2(unsafe);
  } catch (e) {
    sink(e); // NOT OK
  }

  try {
    throwRaw2(safe);
  } catch (e) {
    sink(e); // OK
  }

  try {
    throwError2(source());
  } catch (e) {
    sink(e); // NOT OK
    sink(e.toString()); // NOT OK
    sink(e.message); // NOT OK
    sink(e.fileName); // OK - but flagged anyway
  }

  try {
    throwError2(unsafe);
  } catch (e) {
    sink(e); // NOT OK
    sink(e.toString()); // NOT OK
    sink(e.message); // NOT OK
    sink(e.fileName); // OK - but flagged anyway
  }

  try {
    throwError2(safe);
  } catch (e) {
    sink(e); // NOT OK
    sink(e.toString()); // NOT OK
    sink(e.message); // NOT OK
    sink(e.fileName); // OK - but flagged anyway
  }

  try {
    throwAsync(source());
  } catch (e) {
    sink(e); // OK - but flagged anyway
  }

  throwAsync(source()).catch(e => {
    sink(e); // NOT OK - but not flagged
  });

  async function asyncTester() {
    try {
      await throwAsync(source());
    } catch (e) {
      sink(e); // NOT OK
    }
  }
}

function throwRaw2(x) {
  throwRaw1(x);
  throwRaw1(x); // no single-call inlining
}

function throwRaw1(x) {
  throw x;
}

function throwError2(x) {
  throwError1(x);
  throwError1(x); // no single-call inlining
}

function throwError1(x) {
  throw new Error(x);
}

async function throwAsync(x) {
  throw x; // doesn't actually throw - returns failed promise
}

test(source(), "hello");
test("hey", "hello"); // no single-call inlining

// semmle-extractor-options: --experimental
