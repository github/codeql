function f() {
  var x = 1;
  var x = 2; // $ Alert
}

function g(x) {
  var x = 1; // $ Alert
}

function h() {
  var i = 1;
  for (var i = 0; i < 10; i++) { // $ Alert
  }
}

function k() {
  var y = 1;
  var x = 2,
      y = 2; // $ Alert
}

var g; // $ Alert
