function f(x, y) { // $ Alert
  return y;
}

function g(x, y) {
  return y + arguments[0];
}

function h(x) {
  function inner() {
    x = 1;
  }
}


/**
 * @param {*} x the first argument, deliberately unused
 * @param {*} y the second argument
 */
function K(x, y) {
    return y;
}

/**
 * @param {*} x the first argument
 * @param {*} y the second argument
 */
function K(x, y) { // $ Alert
    return y;
}


/**
 * @abstract
 * @param {*} x the first argument
 * @param {*} y the second argument
 */
A.prototype.f = function(x, y) {};
