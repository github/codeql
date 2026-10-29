var A = A || {};
A.foo = function() {};
A.bar = {
  baz: function() {}
};

var B = {};
B.a = A;

(function(m) {
  m.qux = function() {};
})(A);

var x1 = A;
var x2 = A.foo;
var x3 = A.bar;
var x4 = A.bar.baz;
var x5 = B;
var x6 = B.a;
var x7 = B.a.bar.baz;
var x8 = A.qux;

(function() {
  var o = {
    q: {
      r: 42
    }
  };
  var x1 = o;
  var x2 = o.q;
  var x3 = o.q.r;

  var o2 = {
    f() {},
    g() {
      var x4 = this;
      var x5 = this.f;
      var x6 = this.h;
    }
  };
  o2.h = function() {};

  var o3 = {
    __proto__: o2
  };
  o3.__proto__ = null;
  o3.__proto__ = 42; // has no effect
})();
