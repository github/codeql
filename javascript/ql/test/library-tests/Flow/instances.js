function A() {
  this.x = 42;
  this.foo = function() {};
}

A.prototype.bar = function() {};

var a = new A();
var x1 = a.x;
var x2 = a.foo;
var x3 = a.bar;

function SubA() {}
SubA.prototype = new A();

var subA = new SubA();
