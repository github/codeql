/**
 * NOT OK: The following param tag has a misspelled value.
 *
 * @param prameter The parameter's value.
 */ 
function typo(parameter){ return parameter+19; }

/**
 * NOT OK: The following param tag appears to be outdated
 * since the method does not take any parameters.
 *
 * @param sign The number's sign.
 */ 
function outdated(){ return 42; }

/**
 * OK
 *
 * @param ordinate The value of the y coordinate.
 */ 
function good(ordinate){ return ''; }

/**
 * OK: namepath
 *
 * @param o.x The property 'x'.
 */
function good2(o) { return o.x; }

/**
 * OK: Function has complicated signature that cannot be directly
 * expressed using parameter list.
 *
 * @param {string?} firstName
 * @param {string} lastName
 */
function good3() {
  var firstName, sep, lastName;
  if (arguments.length > 1) {
    firstName = arguments[0];
    sep = " ";
    lastName = arguments[1];
  } else {
    firstName = sep = "";
    lastName = arguments[0];
  }
  return firstName + sep + lastName;
}

/**
 * @param {IncomingMessage} opts
 */
var Cookie = foo.bar = function Cookie(options) {
}

/**
 * @param {IncomingMessage} opts
 */
Cookie2 = foo.bar2 = function Cookie2(options) {
}
