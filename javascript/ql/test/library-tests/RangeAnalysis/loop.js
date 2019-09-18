function increasing(start, end) {
  for (var i = start; i < end; ++i) {
    if (i >= start) {} // NOT OK - always true
    if (i < start) {}  // NOT OK - always false
    
    if (i < end) {}    // NOT OK - always true
    if (i >= end) {}   // NOT OK - always false
    
    if (i + 1 > start) {} // NOT OK - always true
    if (i - 1 < start) {} // OK 
  }
}

function decreasing(start, end) {
  for (var i = start; i > end; --i) {
    if (i <= start) {} // NOT OK - always true
    if (i > start) {}  // NOT OK - always false
    
    if (i + 1 > start) {} // OK
    if (i - 1 < start) {} // NOT OK - always true
  }
}

function middleIncrement(start, end) {
  for (var i = start; i < end;) {
    if (i >= start) {} // OK - always true but we don't catch it
    if (i < start) {}  // OK - always false but we don't catch it
    
    if (i < end) {}    // NOT OK - always true
    if (i >= end) {}   // NOT OK - always false
    
    if (something()) {
        i += 2;
    }
    if (i >= start) {} // OK - always true but we don't catch it
    if (i < start) {}  // OK - always false but we don't catch it
    if (i < end) {}    // OK
    if (i >= end) {}   // OK
  }
}
