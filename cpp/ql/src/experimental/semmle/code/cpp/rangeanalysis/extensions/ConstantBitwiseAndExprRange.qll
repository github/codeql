private import cpp
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
private import experimental.semmle.code.cpp.rangeanalysis.BinaryOrAssignOperation

/**
 * The current implementation for `BitwiseAndExpr` only handles cases where both operands are
 * either unsigned or non-negative constants. This class not only covers these cases, but also
 * adds support for `&` expressions between a signed integer with a non-negative range and a
 * non-negative constant. It also adds support for `&=` for the same set of cases as `&`.
 */
private class ConstantBitwiseAndExprRange extends SimpleRangeAnalysisExpr {
  BinaryOrAssignConstantBitwiseAndExpr e;

  ConstantBitwiseAndExprRange() { this = e.getOperation() }

  BinaryOrAssignConstantBitwiseAndExpr getExpr() { result = e }

  Expr getLeftOperand() { result = e.getLeftOperand() }

  Expr getRightOperand() { result = e.getRightOperand() }

  override float getLowerBounds() { result = e.getLowerBounds() }

  override float getUpperBounds() { result = e.getUpperBounds() }

  override predicate dependsOnChild(Expr child) { child = e.getAnOperand() }
}

private class ConstantBitwiseAndExprOp extends Expr {
  BinaryOrAssignConstantBitwiseAndExpr b;
  float lowerBound;
  float upperBound;

  ConstantBitwiseAndExprOp() {
    this = b.getAnOperand() and
    lowerBound = getFullyConvertedLowerBounds(this) and
    upperBound = getFullyConvertedUpperBounds(this) and
    lowerBound <= upperBound
  }

  float getLowerBound() { result = lowerBound }

  float getUpperBound() { result = upperBound }

  predicate hasNegativeRange() { getLowerBound() < 0 or getUpperBound() < 0 }
}

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

private class BinaryOrAssignConstantBitwiseAndExpr extends BinaryOrAssignOperation {
  BinaryOrAssignConstantBitwiseAndExpr() {
    (
      getOperation() instanceof BitwiseAndExpr
      or
      getOperation() instanceof AssignAndExpr
    ) and
    // Make sure all operands and the result type are integral
    getOperation().getUnspecifiedType() instanceof IntegralType and
    getLeftOperand().getUnspecifiedType() instanceof IntegralType and
    getRightOperand().getUnspecifiedType() instanceof IntegralType and
    // No operands can be negative constants
    not (evaluateConstantExpr(getLeftOperand()) < 0 or evaluateConstantExpr(getRightOperand()) < 0) and
    // At least one operand must be a non-negative constant
    (evaluateConstantExpr(getLeftOperand()) >= 0 or evaluateConstantExpr(getRightOperand()) >= 0)
  }

  float getLowerBounds() {
    // If both operands have non-negative ranges, the lower bound is zero. If an operand can have
    // negative values, the lower bound is unconstrained.
    exists(ConstantBitwiseAndExprOp l, ConstantBitwiseAndExprOp r |
      l = getLeftOperand() and
      r = getRightOperand() and
      (
        (l.hasNegativeRange() or r.hasNegativeRange()) and
        result = exprMinVal(getOperation())
        or
        // This technically results in two lowerBounds when an operand range is negative, but
        // that's fine since `exprMinVal(x) <= 0`. We can't use an if statement here without
        // non-monotonic recursion issues
        result = 0
      )
    )
  }

  float getUpperBounds() {
    // If an operand can have negative values, the upper bound is unconstrained.
    // Otherwise, the upper bound is the maximum of the upper bounds of the operands
    exists(ConstantBitwiseAndExprOp l, ConstantBitwiseAndExprOp r |
      l = getLeftOperand() and
      r = getRightOperand() and
      (
        (l.hasNegativeRange() or r.hasNegativeRange()) and
        result = exprMaxVal(getOperation())
        or
        // This technically results in two upperBounds when an operand range is negative, but
        // that's fine since `exprMaxVal(b) >= result`
        result = r.getUpperBound().minimum(l.getUpperBound())
      )
    )
  }
}
