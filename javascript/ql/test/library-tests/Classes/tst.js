let A = class {
  "constructor"() { /* This is a constructor. */ }
  ["constructor"]() { /* This is not a constructor. */ }
}

class B extends A {
  constructor() { super(new.target); }
}

let m = "n";
class C {
  m() {}
  [m]() {}
}

var o = {
  m() { return 42; }
};
