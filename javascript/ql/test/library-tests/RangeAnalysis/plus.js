function f(x,y) {
  if (x + 1 < y) {
    if (x < y) {}       // NOT OK - always true
    if (x + 1 < y) {}   // NOT OK - always true
    if (x + 1 <= y) {}  // NOT OK - always true
    if (x > y) {}       // NOT OK - always false
    if (x >= y) {}      // NOT OK - always false
    if (x + 1 >= y) {}  // NOT OK - always false
    if (x + 2 < y) {}   // OK
    if (x < y - 1) {}   // NOT OK - always true
  }
  if (x < y + 1) {
    if (x < y) {}      // OK
    if (x + 1 < y) {}  // OK
    if (x - 1 < y) {}  // NOT OK - always true
  }
}

function g(x) {
  let z = x + 1;
  z += 1;
  ++z;
  z++;
  if (z < x + 4) {} // NOT OK - always false
  if (z > x + 4) {} // NOT OK - always false
  if (z < x + 5) {} // NOT OK - always true
  if (z > x + 5) {} // NOT OK - always false 
}

function h(x) {
  let y = x++;
  if (x > y) {} // NOT OK - always true
}
