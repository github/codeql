private import cpp
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

float evaluateConstantExpr1(Expr e) {
  result = e.getValue().toFloat()
  or
  // This handles when a constant value is put into a variable
  // and the variable is used later
  exists(SsaDefinition defn, StackVariable sv |
    defn.getAUse(sv) = e and
    result = defn.getDefiningValue(sv).getValue().toFloat()
  )
}

// If the constant right operand is negative or is greater than or equal to the number of
// bits in the left operands type, then the result is undefined (except on the IA-32
// architecture where the shift value is masked with 0b00011111, but we can't
// assume the architecture).
bindingset[val]
pragma[inline]
private predicate isValidShiftExprShift(float val, Expr l) {
  val >= 0 and
  // We use getFullyConverted because the spec says to use the *promoted* left operand
  val < (l.getFullyConverted().getUnderlyingType().getSize() * 8)
}

/**
 * This handles the `>>` and `>>=` operators when at least one operand is a constant (and if the
 * right operand is a constant, it must be "valid" (see `isValidShiftExprShift`)). When handling any
 * undefined behavior, it leaves the values unconstrained. From the C++ standard: "The behavior is
 * undefined if the right operand is negative, or greater than or equal to the length in bits of the
 * promoted left operand. The value of E1 >> E2 is E1 right-shifted E2 bit positions. If E1 has an
 * unsigned type or if E1 has a signed type and a non-negative value, the value of the result is the
 * integral part of the quotient of E1/2^E2. If E1 has a signed type and a negative value, the
 * resulting value is implementation-defined."
 */
class ConstantRShiftExprRange extends SimpleRangeAnalysisExpr {
  /**
   * Holds for `a >> b` or `a >>= b` in one of the following two cases:
   * 1. `a` is a constant and `b` is not
   * 2. `b` is constant
   *
   * We don't handle the case where `a` and `b` are both non-constant values.
   */
  ConstantRShiftExprRange() {
    getUnspecifiedType() instanceof IntegralType and
    exists(Expr l, Expr r |
      l = this.(RShiftExpr).getLeftOperand() and
      r = this.(RShiftExpr).getRightOperand()
      or
      l = this.(AssignRShiftExpr).getLValue() and
      r = this.(AssignRShiftExpr).getRValue()
    |
      l.getUnspecifiedType() instanceof IntegralType and
      r.getUnspecifiedType() instanceof IntegralType and
      (
        // If the left operand is a constant, verify that the right operand is not a constant
        exists(evaluateConstantExpr1(l)) and not exists(evaluateConstantExpr1(r))
        or
        // If the right operand is a constant, check if it is a valid shift expression
        exists(float constROp |
          constROp = evaluateConstantExpr1(r) and isValidShiftExprShift(constROp, l)
        )
      )
    )
  }

  Expr getLeftOperand() {
    result = this.(RShiftExpr).getLeftOperand() or
    result = this.(AssignRShiftExpr).getLValue()
  }

  Expr getRightOperand() {
    result = this.(RShiftExpr).getRightOperand() or
    result = this.(AssignRShiftExpr).getRValue()
  }

  override float getLowerBounds() {
    exists(int lLower, int lUpper, int rLower, int rUpper |
      lLower = getFullyConvertedLowerBounds(getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(getRightOperand()) and
      lLower <= lUpper and
      rLower <= rUpper
    |
      if
        lLower < 0
        or
        not (
          isValidShiftExprShift(rLower, getLeftOperand()) and
          isValidShiftExprShift(rUpper, getLeftOperand())
        )
      then
        // We don't want to deal with shifting negative numbers at the moment,
        // and a negative shift is implementation defined, so we set the result
        // to the minimum value
        result = exprMinVal(this)
      else
        // We can get the smallest value by shifting the smallest bound by the largest bound
        result = lLower.bitShiftRight(rUpper)
    )
  }

  override float getUpperBounds() {
    exists(int lLower, int lUpper, int rLower, int rUpper |
      lLower = getFullyConvertedLowerBounds(getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(getRightOperand()) and
      lLower <= lUpper and
      rLower <= rUpper
    |
      if
        lLower < 0
        or
        not (
          isValidShiftExprShift(rLower, getLeftOperand()) and
          isValidShiftExprShift(rUpper, getLeftOperand())
        )
      then
        // We don't want to deal with shifting negative numbers at the moment,
        // and a negative shift is implementation defined, so we set the result
        // to the maximum value
        result = exprMaxVal(this)
      else
        // We can get the largest value by shifting the largest bound by the smallest bound
        result = lUpper.bitShiftRight(rLower)
    )
  }

  override predicate dependsOnChild(Expr child) {
    child = getLeftOperand() or child = getLeftOperand()
  }
}
