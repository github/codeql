function f() {
  if (1 > 0) {}      // NOT OK - always true
  if (1 - 1 >= 0) {} // NOT OK - always true
  let one = 1;
  let two = 2;
  if (two > one) {}  // NOT OK - always true
  if (two <= one) {} // NOT OK - always false
}
