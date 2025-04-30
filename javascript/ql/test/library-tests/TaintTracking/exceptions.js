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
    sink(e.fileName); // OK - but flagged anyway [INCONSISTENCY]
  }

  try {
    throwError2(unsafe);
  } catch (e) {
    sink(e); // NOT OK
    sink(e.toString()); // NOT OK
    sink(e.message); // NOT OK
    sink(e.fileName); // OK - but flagged anyway [INCONSISTENCY]
  }

  try {
    throwError2(safe);
  } catch (e) {
    sink(e); // OK
    sink(e.toString()); // OK
    sink(e.message); // OK
    sink(e.fileName); // OK
  }

  try {
    throwAsync(source());
  } catch (e) {
    sink(e); // OK
  }

  throwAsync(source()).catch(e => {
    sink(e); // NOT OK
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

function testNesting(x) {
  try {
    throw source();
  } catch (e) {
    sink(e); // NOT OK
  }

  try {
    try {
      throw source();
    } catch (e) {
      sink(e); // NOT OK
    }
  } catch (e) {
    sink(e); // OK - not caught by this catch
  }

  try {
    if (x) {
      for (;x;) {
        while(x) {
          switch (x) {
            case 1:
            default:
              throw source();
          }
        }
      }
    }
  } catch (e) {
    sink(e); // NOT OK
  }
}

function testThrowSourceInCallee() {
  try {
    throwSource();
  } catch (e) {
    sink(e); // NOT OK
  }

  sink(returnThrownSource()); // NOT OK
}

function returnThrownSource() {
  try {
    throwSource();
  } catch (e) {
    return e;
  }
}

function throwSource() {
  throw source();
}

function throwThoughLibrary(xs) {
  try {
    xs.forEach(function() {
      throw source();
    })
  } catch (e) {
    sink(e); // NOT OK
  }

  try {
    _.takeWhile(xs, function() {
      throw source();
    })
  } catch (e) {
    sink(e); // NOT OK
  }

  try {
    window.addEventListener("message", function(e) {
      throw source();
    })
  } catch (e) {
    sink(e); // OK - doesn't catch exception from event listener
  }
}
