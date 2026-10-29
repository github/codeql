import 'dummy';

class A {
  /** name:A.f */
  f() {}
}

class B {
  /** name:B.f */
  f() {}
}

function g(a) {
  /** calls:A.f */
  a.f();
}
g(new A);
g(new A);

function h(b) {
  /** calls:B.f */
  b.f();
}
h(new B);
h(new B);

function either(ab) {
  /**
   * calls:A.f
   * calls:B.f
   */
  ab.f();
}
either(new A);
either(new B);
