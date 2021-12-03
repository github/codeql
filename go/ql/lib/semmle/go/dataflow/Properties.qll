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
  private predicate checkOnExpr(Expr test, Boolean outcome, DataFlow::Node nd) {
    exists(EqualityTestExpr eq, Expr e, boolean isTrue |
      eq = test and eq.hasOperands(nd.asExpr(), e)
    |
      this = IsBoolean(isTrue) and
      isTrue = eq.getPolarity().booleanXor(e.getBoolValue().booleanXor(outcome))
      or
      this = IsNil(isTrue) and
      e = Builtin::nil().getAReference() and
      isTrue = eq.getPolarity().booleanXor(outcome).booleanNot()
    )
    or
    // if test = outcome ==> nd matches this
    // then !test = !outcome ==> nd matches this
    this.checkOnExpr(test.(NotExpr).getOperand(), outcome.booleanNot(), nd)
    or
    // if test = outcome ==> nd matches this
    // then (test) = outcome ==> nd matches this
    this.checkOnExpr(test.(ParenExpr).getExpr(), outcome, nd)
    or
    // if test = true ==> nd matches this
    // then (test && e) = true ==> nd matches this
    outcome = true and
    this.checkOnExpr(test.(LandExpr).getAnOperand(), outcome, nd)
    or
    // if test = false ==> nd matches this
    // then (test || e) = false ==> nd matches this
    outcome = false and
    this.checkOnExpr(test.(LorExpr).getAnOperand(), outcome, nd)
    or
    test = nd.asExpr() and
    test instanceof ValueExpr and
    test.getType().getUnderlyingType() instanceof BoolType and
    this = IsBoolean(outcome)
  }

  /**
   * Holds if `test` evaluating to `outcome` means that this property holds of `nd`, where `nd` is a
   * subexpression of `test`.
   */
  predicate checkOn(DataFlow::Node test, Boolean outcome, DataFlow::Node nd) {
    this.checkOnExpr(test.asExpr(), outcome, nd)
  }

  /** Holds if this is the property of having the Boolean value `b`. */
  predicate isBoolean(boolean b) { this = IsBoolean(b) }

  /** Returns the boolean represented by this property if it is a boolean. */
  boolean asBoolean() { this = IsBoolean(result) }

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

/**
 * Gets a `Property` representing truth outcome `b`.
 */
Property booleanProperty(boolean b) { result = IsBoolean(b) }

/**
 * Gets a `Property` representing `nil`-ness.
 */
Property nilProperty() { result = IsNil(true) }

/**
 * Gets a `Property` representing non-`nil`-ness.
 */
Property notNilProperty() { result = IsNil(false) }
