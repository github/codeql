function test() {
  let x = source();

  if (isTypeA(x)) {
    if (sanitizeA(x)) {
      sink(x); // OK
    } else {
      sink(x); // NOT OK
    }

    if (sanitizeB(x)) {
      sink(x); // NOT OK
    } else {
      sink(x); // NOT OK
    }
  } else {
    if (sanitizeA(x)) {
      sink(x); // NOT OK
    } else {
      sink(x); // NOT OK
    }

    if (sanitizeB(x)) {
      sink(x); // OK
    } else {
      sink(x); // NOT OK
    }
  }

  if (sanitizeA(x) && sanitizeB(x)) {
    sink(x); // OK
  }
}
