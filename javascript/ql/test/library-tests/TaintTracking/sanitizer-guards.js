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
        sink(this.x); // OK - but still flagged
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
