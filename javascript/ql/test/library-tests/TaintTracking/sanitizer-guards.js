function test() {
  let x = source();

  sink(x); // NOT OK

  if (isSafe(x)) {
    sink(x); // OK
  }
}

class C {
  method() {
    this.x = source();

    sink(this.x); // NOT OK

    if (isSafe(this.x)) {
      sink(this.x); // OK

      addEventListener('hey', () => {
        sink(this.x); // OK - but still flagged [INCONSISTENCY]
      });
    }

    addEventListener('hey', () => {
	  sink(this.x); // NOT OK
	});

	let self = this;
	if (isSafe(self.x)) {
	  sink(self.x); // OK
	}

	addEventListener('hey', function() {
	  if (isSafe(self.x)) {
	    sink(self.x); // OK
	  }
	});
  }
}

function reflective() {
  let x = source();

  sink(x); // NOT OK

  if (isSafe.call(x)) {
    sink(x); // NOT OK - `isSafe` does not sanitize the receiver
  }

  if (isSafe.call(null, x)) {
    sink(x); // OK
  }
}

function phi() {
  let x = source();

  if (something(x) && isSafe(x)) {
    // this input to the phi node for 'x' should be sanitized
  } else {
    x = null;
  }
  sink(x); // OK
}

function phi2() {
  let x = source();

  if (something(x) || isSafe(x)) {
    // this input to the phi node for 'x' is not fully sanitized
  } else {
    x = null;
  }
  sink(x); // NOT OK
}

function fallbackAssignment() {
  let x = source();

  if (!isSafe(x)) {
    x = "safe";
  }
  sink(x); // OK
}

function fallbackAssignmentElse() {
  let x = source();

  if (isSafe(x)) {
    // The checked value is safe.
  } else {
    x = "safe";
  }
  sink(x); // OK
}

function fallbackUnsafe() {
  let x = source();

  if (!isSafe(x)) {
    x = source();
  }
  sink(x); // NOT OK: the fallback is tainted.
}

function fallbackWrongPolarity() {
  let x = source();
  if (isSafe(x)) {
    x = "safe";
  }
  sink(x); // NOT OK - the fall-through edge is unchecked
}

function fallbackGuardOnOtherVariable() {
  let x = source();
  let y = source();
  if (!isSafe(y)) {
    x = "safe";
  }
  sink(x); // NOT OK - the guard checks y, not x
}

function fallbackLoopInsideGuard() {
  let x = source();
  if (isSafe(x)) {
    while (cond()) {
      x = "safe";
    }
    sink(x); // OK
  }
}

function falsy() {
  let x = source();

  sink(x); // NOT OK

  if (x) {
    sink(x); // NOT OK (for taint-tracking)
  } else {
	  sink(x); // OK
  }
}

function comparisons() {
  let x = source();

  sink(x); // NOT OK

  if (x === "foo") {
    sink(x); // OK
  } else {
	sink(x); // NOT OK
  }

  if (x === something()) {
    sink(x); // OK
  } else {
	sink(x); // NOT OK
  }
}
