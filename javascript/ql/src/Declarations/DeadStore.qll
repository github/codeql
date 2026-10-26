/**
 * Provides classes and predicates for reasoning about dead stores.
 */

import javascript

/**
 * Holds if `e` is an expression that may be used as a default initial value,
 * such as `0` or `-1`, or an empty object or array literal.
 */
predicate isDefaultInit(Expr e) {
  // primitive default values: zero, false, empty string, and (integer) -1
  e.(NumberLiteral).getValue().toFloat() = 0.0 or
  e.(NegExpr).getOperand().(NumberLiteral).getValue() = "1" or
  e.getStringValue() = "" or
  e.(BooleanLiteral).getValue() = "false" or
  // initialising to an empty array or object literal, even if unnecessary,
  // can convey useful type information to the reader
  e.(ArrayExpr).getSize() = 0 or
  e.(ObjectExpr).getNumProperty() = 0 or
  SyntacticConstants::isNullOrUndefined(e)
}
