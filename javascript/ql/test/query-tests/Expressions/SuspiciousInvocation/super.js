class A extends null {
  constructor() {
    // OK: calls `Function.prototype`
    super();
  }
}

class B extends 42 {
  constructor() {
    // NOT OK
    super();
  }
}