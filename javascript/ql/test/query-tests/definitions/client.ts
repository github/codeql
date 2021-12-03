import * as lib from "./tslib";

class C {
  m() {}
}

function f(x: lib.C) {
  let c: C;
  let d: Array<C>;
  let n: lib.N.C;
}

function methodCalls(x: C, y: lib.C, z: lib.N.C) {
  x.m();
  y.m();
  z.m();
}
