class A {
  constructor() {
    ctor;
  }
  x;
  static y;
  f() {}
  static g() {}
}

class B extends A {
  constructor() {
    before;
    super();
    after;
  }
  z;
}
