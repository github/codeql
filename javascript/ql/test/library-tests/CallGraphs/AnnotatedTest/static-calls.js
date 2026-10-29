import 'dummy';

class C {
  /** name:C.f */
  static f() {}
}

class D {
  /** name:D.f */
  static f() {}
}

function g(c) {
  /** calls:C.f */
  c.f();
}
g(C);
g(C);

function h(d) {
  /** calls:D.f */
  d.f();
}
h(D);
h(D);

function either(cd) {
  /**
   * calls:C.f
   * calls:D.f
   */
  cd.f();
}
either(C);
either(D);
