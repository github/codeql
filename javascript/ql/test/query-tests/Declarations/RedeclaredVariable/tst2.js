function f(x) {
  function g() {
    try {
    } finally {
      var x;
    }
  }
}

function h(x, y) {
  if (arguments.length < 2)
    [x, y] = x;
}