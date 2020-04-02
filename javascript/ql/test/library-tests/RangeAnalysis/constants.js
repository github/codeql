function f() {
  if (1 > 0) {}      // NOT OK - always true
  if (1 - 1 >= 0) {} // NOT OK - always true
  let one = 1;
  let two = 2;
  if (two > one) {}  // NOT OK - always true
  if (two <= one) {} // NOT OK - always false
}

function underscores(x) {
  if (x >= 1_000_000) return; // OK
  if (x >= 1_000) return; // OK
}
