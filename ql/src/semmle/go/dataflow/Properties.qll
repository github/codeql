/**
 * Provides a class for representing and reasoning about properties of data-flow nodes.
 */

import go

private newtype TProperty =
  IsBoolean(Boolean b) or
  IsNil(Boolean b)

/**
 * A property which may or may not hold of a data-flow node.
 *
 * Supported properties currently are Boolean truth and `nil`-ness.
 */
class Property extends TProperty {
  /**
   * Holds if `test` evaluating to `outcome` means that this property holds of `nd`.
   */
  predicate checkOn(DataFlow::Node test, Boolean outcome, DataFlow::Node nd) {
    exists(EqualityTestExpr eq, Expr e, boolean isTrue |
      eq = test.asExpr() and eq.hasOperands(nd.asExpr(), e)
    |
      this = IsBoolean(isTrue) and
      isTrue = eq.getPolarity().booleanXor(e.getBoolValue().booleanXor(outcome))
      or
      this = IsNil(isTrue) and
      e = Builtin::nil().getAReference() and
      isTrue = eq.getPolarity().booleanXor(outcome).booleanNot()
    )
    or
    test = nd and
    test.asExpr() instanceof ValueExpr and
    test.getType().getUnderlyingType() instanceof BoolType and
    this = IsBoolean(outcome)
  }

  /** Holds if this is the property of having the Boolean value `b`. */
  predicate isBoolean(boolean b) { this = IsBoolean(b) }

  /** Holds if this is the property of being `nil`. */
  predicate isNil() { this = IsNil(true) }

  /** Holds if this is the property of being non-`nil`. */
  predicate isNonNil() { this = IsNil(false) }

  /** Gets a textual representation of this property. */
  string toString() {
    exists(boolean b |
      this = IsBoolean(b) and
      result = "is " + b
    )
    or
    this = IsNil(true) and
    result = "is nil"
    or
    this = IsNil(false) and
    result = "is not nil"
  }
}
