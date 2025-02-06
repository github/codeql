class Class1 {
  constructor(x) { this.x = x; }
}
new Class1(42, 23); // $ Alert - `23` is ignored

class Sup {
  constructor(x) { this.x = x; }
}

class Sub extends Sup {
}

new Sub(42); // OK - synthetic constructor delegates to super constructor

class Other {}

new Other(42); // $ Alert - `42` is ignored

var args = [];
f(...args);
f(42, ...args); // $ Alert