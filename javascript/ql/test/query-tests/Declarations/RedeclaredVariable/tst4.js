function f() {
  var x = 1;
  var x = 2; // NOT OK
}

function g(x) {
  var x = 1; // NOT OK
}

function h() {
  var i = 1;
  for (var i = 0; i < 10; i++) { // NOT OK
  }
}

function k() {
  var y = 1;
  var x = 2,
      y = 2; // NOT OK
}

var g;
