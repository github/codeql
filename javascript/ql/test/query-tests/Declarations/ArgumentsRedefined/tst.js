function f() {
  if (arguments[0].isArray())
    arguments = arguments[0]; // NOT OK
}

function g(x, y) {
  var arguments = [y, x]; // NOT OK
}
