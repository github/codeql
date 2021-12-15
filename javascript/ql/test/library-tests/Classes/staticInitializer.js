class MyClass {
  static x = 1;
  constructor() {
    this.y = 2;
  }
  static {
    MyClass.z = 3;
  }
  foo() {
    this.t = 4;
  }
  static bar() {
    this.u = 5;
  }
  static {
    this.v = 6;
  }
}