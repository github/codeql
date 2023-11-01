private import cpp
private import experimental.semmle.code.cpp.models.interfaces.SimpleRangeAnalysisExpr
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

float evaluateConstantExpr(Expr e) {
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
private predicate isValidShiftExprShift(float val, Expr l) {
  val >= 0 and
  // We use getFullyConverted because the spec says to use the *promoted* left operand
  val < (l.getFullyConverted().getUnderlyingType().getSize() * 8)
}

bindingset[val, shift, max_val]
private predicate canLShiftOverflow(int val, int shift, int max_val) {
  // val << shift = val * 2^shift > max_val => val > max_val/2^shift = max_val >> b
  val > max_val.bitShiftRight(shift)
}

/**
 * A range analysis expression consisting of the `>>` or `>>=` operator when at least
 * one operand is a constant (and if the right operand is a constant, it must be "valid"
 * (see `isValidShiftExprShift`)). When handling any undefined behavior, it leaves the
 * values unconstrained. From the C++ standard: "The behavior is undefined if the right
 * operand is negative, or greater than or equal to the length in bits of the promoted
 * left operand. The value of E1 >> E2 is E1 right-shifted E2 bit positions. If E1 has an
 * unsigned type or if E1 has a signed type and a non-negative value, the value of the
 * result is the integral part of the quotient of E1/2^E2. If E1 has a signed type and a
 * negative value, the resulting value is implementation-defined."
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
    this.getUnspecifiedType() instanceof IntegralType and
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
        exists(evaluateConstantExpr(l)) and not exists(evaluateConstantExpr(r))
        or
        // If the right operand is a constant, check if it is a valid shift expression
        exists(float constROp |
          constROp = evaluateConstantExpr(r) and isValidShiftExprShift(constROp, l)
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
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(this.getRightOperand()) and
      lLower <= lUpper and
      rLower <= rUpper
    |
      if
        lLower < 0
        or
        not (
          isValidShiftExprShift(rLower, this.getLeftOperand()) and
          isValidShiftExprShift(rUpper, this.getLeftOperand())
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
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(this.getRightOperand()) and
      lLower <= lUpper and
      rLower <= rUpper
    |
      if
        lLower < 0
        or
        not (
          isValidShiftExprShift(rLower, this.getLeftOperand()) and
          isValidShiftExprShift(rUpper, this.getLeftOperand())
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
    child = this.getLeftOperand() or child = this.getRightOperand()
  }
}

/**
 * A range analysis expression consisting of the `<<` or `<<=` operator when at least
 * one operand is a constant (and if the right operand is a constant, it must be "valid"
 * (see `isValidShiftExprShift`)). When handling any undefined behavior, it leaves the
 * values unconstrained. From the C++ standard: "The behavior is undefined if the right
 * operand is negative, or greater than or equal to the length in bits of the promoted left operand.
 * The value of E1 << E2 is E1 left-shifted E2 bit positions; vacated bits are zero-filled. If E1
 * has an unsigned type, the value of the result is E1 x 2 E2, reduced modulo one more than the
 * maximum value representable in the result type. Otherwise, if E1 has a signed type and
 * non-negative value, and E1 x 2 E2 is representable in the corresponding unsigned type of the
 * result type, then that value, converted to the result type, is the resulting value; otherwise,
 * the behavior is undefined."
 */
class ConstantLShiftExprRange extends SimpleRangeAnalysisExpr {
  /**
   * Holds for `a << b` or `a <<= b` in one of the following two cases:
   * 1. `a` is a constant and `b` is not
   * 2. `b` is constant
   *
   * We don't handle the case where `a` and `b` are both non-constant values.
   */
  ConstantLShiftExprRange() {
    this.getUnspecifiedType() instanceof IntegralType and
    exists(Expr l, Expr r |
      l = this.(LShiftExpr).getLeftOperand() and
      r = this.(LShiftExpr).getRightOperand()
      or
      l = this.(AssignLShiftExpr).getLValue() and
      r = this.(AssignLShiftExpr).getRValue()
    |
      l.getUnspecifiedType() instanceof IntegralType and
      r.getUnspecifiedType() instanceof IntegralType and
      (
        // If the left operand is a constant, verify that the right operand is not a constant
        exists(evaluateConstantExpr(l)) and not exists(evaluateConstantExpr(r))
        or
        // If the right operand is a constant, check if it is a valid shift expression
        exists(float constROp |
          constROp = evaluateConstantExpr(r) and isValidShiftExprShift(constROp, l)
        )
      )
    )
  }

  Expr getLeftOperand() {
    result = this.(LShiftExpr).getLeftOperand() or
    result = this.(AssignLShiftExpr).getLValue()
  }

  Expr getRightOperand() {
    result = this.(LShiftExpr).getRightOperand() or
    result = this.(AssignLShiftExpr).getRValue()
  }

  override float getLowerBounds() {
    exists(int lLower, int lUpper, int rLower, int rUpper |
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(this.getRightOperand()) and
      lLower <= lUpper and
      rLower <= rUpper
    |
      if
        lLower < 0
        or
        not (
          isValidShiftExprShift(rLower, this.getLeftOperand()) and
          isValidShiftExprShift(rUpper, this.getLeftOperand())
        )
      then
        // We don't want to deal with shifting negative numbers at the moment,
        // and a negative shift is undefined, so we set to the minimum value
        result = exprMinVal(this)
      else
        // If we have `0b01010000 << [0, 2]`, the max value for 8 bits is 0b10100000
        // (a shift of 1) but doing a shift by the upper bound would give 0b01000000.
        // So if the left shift operation causes an overflow, we just assume the max value
        // If necessary, we may be able to improve this bound in the future
        if canLShiftOverflow(lUpper, rUpper, exprMaxVal(this))
        then result = exprMinVal(this)
        else result = lLower.bitShiftLeft(rLower)
    )
  }

  override float getUpperBounds() {
    exists(int lLower, int lUpper, int rLower, int rUpper |
      lLower = getFullyConvertedLowerBounds(this.getLeftOperand()) and
      lUpper = getFullyConvertedUpperBounds(this.getLeftOperand()) and
      rLower = getFullyConvertedLowerBounds(this.getRightOperand()) and
      rUpper = getFullyConvertedUpperBounds(this.getRightOperand()) and
      lLower <= lUpper and
      rLower <= rUpper
    |
      if
        lLower < 0
        or
        not (
          isValidShiftExprShift(rLower, this.getLeftOperand()) and
          isValidShiftExprShift(rUpper, this.getLeftOperand())
        )
      then
        // We don't want to deal with shifting negative numbers at the moment,
        // and a negative shift is undefined, so we set it to the maximum value
        result = exprMaxVal(this)
      else
        // If we have `0b01010000 << [0, 2]`, the max value for 8 bits is 0b10100000
        // (a shift of 1) but doing a shift by the upper bound would give 0b01000000.
        // So if the left shift operation causes an overflow, we just assume the max value
        // If necessary, we may be able to improve this bound in the future
        if canLShiftOverflow(lUpper, rUpper, exprMaxVal(this))
        then result = exprMaxVal(this)
        else result = lUpper.bitShiftLeft(rUpper)
    )
  }

  override predicate dependsOnChild(Expr child) {
    child = this.getLeftOperand() or child = this.getRightOperand()
  }
}
