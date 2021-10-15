function f(x, y) { // NOT OK
  return y;
}

function g(x, y) { // OK
  return y + arguments[0];
}

function h(x) { // OK
  function inner() {
    x = 1;
  }
}

// OK
/**
 * @param {*} x the first argument, deliberately unused
 * @param {*} y the second argument
 */
function K(x, y) {
    return y;
}

// NOT OK
/**
 * @param {*} x the first argument
 * @param {*} y the second argument
 */
function K(x, y) {
    return y;
}

// OK
/**
 * @abstract
 * @param {*} x the first argument
 * @param {*} y the second argument
 */
A.prototype.f = function(x, y) {};
