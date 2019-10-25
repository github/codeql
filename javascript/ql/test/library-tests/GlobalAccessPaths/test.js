function f() {
  let v = foo.bar; // 'foo.bar'
  v.baz; // 'foo.bar.baz'
  let { baz, a, b: {c} } = v;
  let d = c.d; // 'foo.bar.b.c.d'

  let w = window;
  let xy1 = window.x.y; // 'x.y'
  let xy2 = global.x.y; // 'x.y'
  let xy3 = w.x.y; // 'x.y'

  let notUnique = foo.bar;
  if (something()) {
    notUnique = bar.baz;
  }
  notUnique.x; // No global access path

  function localFunction() {}
  class LocalClass {}
}

(function(ns) {
  ns.foo.bar; // 'NS.foo.bar'
})(NS = NS || {});

Conflict = {}; // assigned in multiple files

class GlobalClass {}

function globalFunction() {}

function destruct() {
  let { bar = {} } = foo;
  let v = bar.baz; // 'foo.bar.baz'
}

function lazy() {
  var lazyInit;
  lazyInit = foo.bar; // 'foo.bar'
  lazyInit;
}
