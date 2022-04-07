import 'dummy';

let obj = {
  /** name:obj.f.get */
  get f() {},

  /** name:obj.f.set */
  set f(x) {}
};

/** callsAccessor:obj.f.get */
obj.f;

/** callsAccessor:obj.f.set */
obj.f = 1;

class C {
  /** name:C.f.get */
  static get f() {}

  /** name:C.f.set */
  static set f(x) {}
}

/** callsAccessor:C.f.get */
C.f;

/** callsAccessor:C.f.set */
C.f = 1;


class D {
  /** name:D.f.get */
  get f() {}

  /** name:D.f.set */
  set f(x) {}
}

/** callsAccessor:D.f.get */
new D().f;

/** callsAccessor:D.f.set */
new D().f = 1;

// Avoid regular calls being seen as calls to the accessor itself
/** calls:NONE */
obj.f();

/** calls:NONE */
C.f();

/** calls:NONE */
new D().f();
