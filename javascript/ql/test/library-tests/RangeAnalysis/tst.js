function f(x,y) {
  if (x < y) {
    if (x < y) {}   // NOT OK - always true
    if (x <= y) {}  // NOT OK - always true
    if (x > y) {}   // NOT OK - always false
    if (x >= y) {}  // NOT OK - always false
    if (x === y) {} // NOT OK - always false
  } else {
    if (x < y) {}   // NOT OK - always false
    if (x <= y) {}  // OK - could be equal 
    if (x > y) {}   // OK
    if (x >= y) {}  // NOT OK - always true
    if (x === y) {} // OK
  }
}

function g(x,y) {
  if (x <= y) {
    if (x < y) {}   // OK
    if (x <= y) {}  // NOT OK - always true
    if (x > y) {}   // NOT OK - always false
    if (x >= y) {}  // OK - could be equal
    if (x === y) {} // OK
  } else {
    if (x < y) {}   // NOT OK - always false
    if (x <= y) {}  // NOT OK - always false
    if (x > y) {}   // NOT OK - always true
    if (x >= y) {}  // NOT OK - always true
    if (x === y) {} // NOT OK - always false
  }
}

function loop(start, end) {
  var i;
  for (i = start; i < end; i++) {
    if (i < end) {}  // NOT OK - always true
    if (i >= end) {} // NOT OK - always false
  }
  if (i >= end) {} // NOT OK - always true
  if (i < end) {}  // NOT OK - always false
}

function h(x, y) {
  if (x - y < 0) {
    if (x < y) {} // NOT OK - always true
    if (x >= y) {} // NOT OK - always false
  }
  if (0 < x - y) { // y < x
    if (x <= y) {} // NOT OK - always false
    if (x > y) {}  // NOT OK - always true
  }
}

function nan(x) {
  // This is a NaN comment.
  if (x - 1 < x) {} // OK
}

/**
 * This is a NAN comment.
 */
function nan2(x) {
  if (x - 1 < x) {} // OK
}
