/**
 * @param x The first operand.
 */
function f(x, y) { // $ Alert
    return x+y;
}

/**
 * OK: Neither parameter is documented.
 */
function g(x, y) {
    return x+y;
}

/**
 * @param {int}   x
 * @param {float} y
 */
var o = {
  /**
   * @param {String} x first argument.
   */
  f : function(x, y) { // $ Alert
  }
};
