function tst(z) {
  var y;
  var x1 = true;
  var x2 = false;
  var x3 = 0;
  var x4 = 0.0;
  var x5 = -0.0;
  var x6 = 0.1;
  var x7 = 1;
  var x8 = "";
  var x9 = 'a';
  var xa = /a/;
  var xb = {};
  var xc = [];
  var xd = function(){};
  var xe = 1-unknown();
  var xf = 1+xe;
  var xg = 'a'+2;
  var xh = 'a'+(unknown()?'b':0);
  var xi = 2^unknown();
  var xj = unknown();
  var xk = new Unknown();
  var xl = void(0);
  var xm = typeof xj;
  var xn = xj >= yk;
  var xo = x9 in xk;
  var xp = ++xj;
  var xq = !xj;
  var xr = -xj;
  var xs = +xj;
  var xt = ~xj;
  var xu = delete xj.p;
  var xv = xj -= 2;
  var xw = xj += "a";
  var xx = y;
  var xy = arguments;
  var xz = z;
  var x_ = someGlobal;
}
var someGlobal = 42;

function nonstrict() {
  var thiz = this;
}

function strict() {
  'use strict';
  var thiz = this;
}

function capturedFn() {
  function captured() {}
  function capturing() {
    captured();
  }
  var neverUndefined = captured;
}

!function(x, y) {
  var _x = x;
  var _y = y;
}(42);

!function(...x) {
  var _x = x;
}(23, 42);

!function(x) {
  var _x = x;
}.apply(null, ["hi"]);

!function s(x) {
  if(!x)
    s(42);
  var _x = x;
}();

!function(x) {
  if(!x)
    arguments.callee(42);
  var _x = x;
}();

!function(x) {
  eval("x = 'hi'");
  var _x = x;
}(42);

!function(x) {
  (0,eval)("x = 'hi'");
  var _x = x;
}(42);

(function() {
  function inner() {
    var z = x;
  }
  var x = 23;
  var y1 = x;
  inner();
  x = 'hi';
  var y2 = x;
  inner();
});

(function() {
  var x = arguments;
  var arguments;
})

function tst(arguments) {
  var x = arguments;
}

!function() {
  var x1 = function() {
    return 42;
  }();
  var x2 = function() {
    return Math.random() > 0.5 ? "hi" : null;
  }();
  var x3 = function(y) {
    return x1;
  }(x1);
  var x4 = function() {}();
  var x5 = function() {
    if (Math.random() > 0.5)
      throw new Error();
    return true;
  }();
  var x6 = function() { throw null; }();
}

function tst2(a, b) {
  var a1 = a, b1 = b;
  if (!a && !b) {
    var a2 = a, b2 = b;
  }
  if (!(a || b)) {
    var a3 = a, b3 = b;
  }
}

function tst3(value) {
  var v1 = value;
  if (value == null) {
    var v2 = value;
  }
}

function tst4(o) {
  var x;
  for (x in o) {
    var x1 = x;
  }
  for (var y in o) {
    var y1 = y;
  }
  for (var z of o) {
    var z1 = z;
  }
}

function tst5(o) {
  var x1 = undefined;
  var x2 = arguments.callee;
  var x3 = o.callee;
  if (o !== undefined) {
    var x4 = o;
  }
  var x5 = o;
}

async function awaitFlow(){
    var v;
    var await1 = v;
    if (y) {
        v = await f()
        var await2 = v;
    }

    var await3 = v;
}

var [someOtherGlobal] = [];
var x1 = someOtherGlobal;
