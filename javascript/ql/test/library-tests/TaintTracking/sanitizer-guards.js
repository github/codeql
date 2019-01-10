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
    }
  }
}
