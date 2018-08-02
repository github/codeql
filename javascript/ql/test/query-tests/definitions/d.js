var c = require('./c');

var o = {
  f: function() {}
};

function A() {
  this.x = 42;
}
A.prototype.g = function() {};

class Super {
  m() {}
}

class Sub extends Super {
  n() {}
}

o.f();

var a = new A();
a.x;
a.g();

var x = new Sub();
x.m();
x.n();
