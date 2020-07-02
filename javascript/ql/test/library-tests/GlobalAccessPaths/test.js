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

function dominatingWrite() {
  var obj = Object.create();

  obj.prop1; // no
  obj.prop1 = "foo";
  obj.prop1; // yes

  if (random()) {
    obj.prop2 = "foo";
  }
  obj.prop2; // no

  obj.prop3 = "foo";
  if (random()) {
    obj.prop3; // yes
  }

  obj.prop4 = obj.prop4; // no

  var foo = (obj.prop5 = 2, obj.prop5); // yes
  var bar = (obj.prop6, obj.prop6 = 3); // no
}

(function(){
	var v1 = Object.freeze(foo.bar).baz; // foo.baz.baz
	var v2 = Object.seal(foo.bar).baz; // foo.baz.baz
	let O = Object;
	var v3 = O.seal(foo.bar).baz; // not recognized
});
