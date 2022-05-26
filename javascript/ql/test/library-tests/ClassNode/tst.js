import * as dummy from 'dummy'; // treat as module

class A {
  instanceMethod() {}
  static staticMethod() {}
  
  bar() {}
  
  get baz() {}
}


class A2 extends A {}

function B() {}
B.prototype = Object.create(A.prototype);
B.prototype.foo = function() {}

function C() {}
C.prototype = new B();
C.prototype.bar = function() {}

function D() {}
D.prototype = {
  get getter() {},
  set setter(x) {},
  m() {}
}

class StaticMembers {
  static method() {}
  static get getter() {}
  static set setter(x) {}
}
