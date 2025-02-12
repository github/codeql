class C {
  m() {}
}

class D extends C {
  constructor() {
    super();
  }
}

let c = new C();
C();             // $ Alert
new (x=>x);      // $ Alert
c.m();
new c.m();       // $ MISSING: Alert

var o = {
  f: function() {},
  g() {}
};
o.f();
new o.f();
o.g();
new o.g();       // $ MISSING: Alert

function f(b) {
  var g;
  if (b)
    g = class {};
  else
    g = (() => {});
  console.log();
  if (!b)
    g();
  else
    new g();
}

function* g() {}
async function h() {}

new g()          // $ Alert
new h()          // $ Alert

C.call();        // $ Alert
C.apply();       // $ Alert

class E {
  static call() {}
  static apply() {}
}

E.call();
E.apply();

function invoke(fn) {
  if (typeof fn === "function" && fn.hasOwnProperty("foo")) {
    fn();
  }
}
invoke(C);
invoke(function() {});
