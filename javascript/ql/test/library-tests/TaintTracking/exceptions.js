function test(unsafe, safe) {
  try {
    throw2(source());
  } catch (e) {
    sink(e);
  }

  try {
    throw2(unsafe);
  } catch (e) {
    sink(e);
  }

  try {
    throw2(safe);
  } catch (e) {
    sink(e); // OK
  }
}

function throw2(x) {
  throw1(x);
  throw1(x); // no single-call inlining
}

function throw1(x) {
  throw x;
}


test(source(), "hello");
test("hey", "hello"); // no single-call inlining

