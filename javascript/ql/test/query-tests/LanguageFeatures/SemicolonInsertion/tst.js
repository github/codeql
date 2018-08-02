function tst() {
  var a = { // NOT OK
    'i': 1,
    'j': 2
  }

  return 1 // NOT OK

  if (condition) { // OK
  }

  for (i = 0; i < 10; i++) { // OK
  }

  label: while (condition) { // OK
    break label; // OK
  }

  return 1; // OK

  //pad with enough explicit semicolons to satisfy 90% threshold
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
  foo();
}
