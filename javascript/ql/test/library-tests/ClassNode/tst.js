import * as dummy from 'dummy'; // treat as module

class A {
  instanceMethod() {}
  static staticMethod() {}
  
  bar() {}
}


class A2 extends A {}

function B() {}
B.prototype = Object.create(A.prototype);
B.prototype.foo = function() {}

function C() {}
C.prototype = new B();
C.prototype.bar = function() {}
