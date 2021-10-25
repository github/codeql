function f1() {
  var g;
  var x1 = g;
  if (typeof g === 'function') {
    var x2 = g;
  }
  var x3 = g;
}

function f2() {
  var a = Math.random() > 0.5 ? null : (Math.random() < 0.5 ? 'hi' : 42);
  var x1 = a;
  if (a)
    var x2 = a;
  if ('string' != typeof a) {
    var x3 = a;
    if (!a) {
      var x4 = a;
    } else {
      var x5 = a;
    }
  }
  var x6 = a;
}

function f3() {
  var a;
  if ((typeof a)[0] !== 'u') {
    var x1 = a;
  }
  var x2 = a;
}

function f4(c) {
  var a = c ? {} : function(){};
  if ((typeof a)[0] === 'o') {
    var x1 = a;
  }
  var x2 = a;
}

function f5() {
  var f;
  function inner() {
    var x1 = f;
    f = null;
    var x2 = f;
  }
  var x3 = f;
  if (f) {
    var x4 = f;
  }
  var x5 = f;
  inner();
  var x6 = f;
}

function f6(x) {
  if (typeof x !== 'string')
    return;
  var x2 = x;
}
