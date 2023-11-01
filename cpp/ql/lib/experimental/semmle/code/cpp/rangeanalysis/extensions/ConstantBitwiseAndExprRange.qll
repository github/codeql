private import cpp
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * Holds if `e` is a constant or if it is a variable with a constant value
 */
float evaluateConstantExpr(Expr e) {
  result = e.getValue().toFloat()
  or
  exists(SsaDefinition defn, StackVariable sv |
    defn.getAUse(sv) = e and
    result = defn.getDefiningValue(sv).getValue().toFloat()
  )
}

/**
 * The current implementation for `BitwiseAndExpr` only handles cases where both operands are
 * either unsigned or non-negative constants. This class not only covers these cases, but also
 * adds support for `&` expressions between a signed integer with a non-negative range and a
 * non-negative constant. It also adds support for `&=` for the same set of cases as `&`.
 */
private class ConstantBitwiseAndExprRange extends SimpleRangeAnalysisExpr {
  ConstantBitwiseAndExprRange() {
    exists(Expr l, Expr r |
      l = this.(BitwiseAndExpr).getLeftOperand() and
      r = this.(BitwiseAndExpr).getRightOperand()
      or
      l = this.(AssignAndExpr).getLValue() and
      r = this.(AssignAndExpr).getRValue()
    |
      // No operands can be negative constants
      not (evaluateConstantExpr(l) < 0 or evaluateConstantExpr(r) < 0) and
      // At least one operand must be a non-negative constant
      (evaluateConstantExpr(l) >= 0 or evaluateConstantExpr(r) >= 0)
    )
  }

  Expr getLeftOperand() {
    result = this.(BitwiseAndExpr).getLeftOperand() or
    result = this.(AssignAndExpr).getLValue()
  }

  Expr getRightOperand() {
    result = this.(BitwiseAndExpr).getRightOperand() or
    result = this.(AssignAndExpr).getRValue()
  }

  override float getLowerBounds() {
    // If an operand can have negative values, the lower bound is unconstrained.
    // Otherwise, the lower bound is zero.
    exists(float lLower, float rLower |
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      (
        (lLower < 0 or rLower < 0) and
        result = exprMinVal(this)
        or
        // This technically results in two lowerBounds when an operand range is negative, but
        // that's fine since `exprMinVal(x) <= 0`. We can't use an if statement here without
        // non-monotonic recursion issues
        result = 0
      )
    )
  }

  override float getUpperBounds() {
    // If an operand can have negative values, the upper bound is unconstrained.
    // Otherwise, the upper bound is the minimum of the upper bounds of the operands
    exists(float lLower, float lUpper, float rLower, float rUpper |
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(this.getRightOperand()) and
      (
        (lLower < 0 or rLower < 0) and
        result = exprMaxVal(this)
        or
        // This technically results in two upperBounds when an operand range is negative, but
        // that's fine since `exprMaxVal(b) >= result`. We can't use an if statement here without
        // non-monotonic recursion issues
        result = rUpper.minimum(lUpper)
      )
    )
  }

  override predicate dependsOnChild(Expr child) {
    child = this.getLeftOperand() or child = this.getRightOperand()
  }
}
