/**
 * Provdides a module to calculate constant integer and boolean values.
 */

import java

signature boolean getBoolValSig(Expr e);

signature int getIntValSig(Expr e);

/**
 * Given predicates defining boolean and integer constants, this module
 * calculates additional boolean and integer constants using only the rules that
 * apply to compile-time constants.
 *
 * The input and output predicates are expected to be mutually recursive.
 */
module CalculateConstants<getBoolValSig/1 getBoolVal, getIntValSig/1 getIntVal> {
  /** Gets the value of a constant boolean expression. */
  boolean calculateBooleanValue(Expr e) {
    // No casts relevant to booleans.
    // `!` is the only unary operator that evaluates to a boolean.
    result = getBoolVal(e.(LogNotExpr).getExpr()).booleanNot()
    or
    // Handle binary expressions that have integer operands and a boolean result.
    exists(BinaryExpr b, int left, int right |
      b = e and
      left = getIntVal(b.getLeftOperand()) and
      right = getIntVal(b.getRightOperand())
    |
      (
        b instanceof LTExpr and
        if left < right then result = true else result = false
      )
      or
      (
        b instanceof LEExpr and
        if left <= right then result = true else result = false
      )
      or
      (
        b instanceof GTExpr and
        if left > right then result = true else result = false
      )
      or
      (
        b instanceof GEExpr and
        if left >= right then result = true else result = false
      )
      or
      (
        b instanceof ValueOrReferenceEqualsExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof ValueOrReferenceNotEqualsExpr and
        if left != right then result = true else result = false
      )
    )
    or
    // Handle binary expressions that have boolean operands and a boolean result.
    exists(BinaryExpr b, boolean left, boolean right |
      b = e and
      left = getBoolVal(b.getLeftOperand()) and
      right = getBoolVal(b.getRightOperand())
    |
      (
        b instanceof ValueOrReferenceEqualsExpr and
        if left = right then result = true else result = false
      )
      or
      (
        b instanceof ValueOrReferenceNotEqualsExpr and
        if left != right then result = true else result = false
      )
      or
      (b instanceof AndBitwiseExpr or b instanceof AndLogicalExpr) and
      result = left.booleanAnd(right)
      or
      (b instanceof OrBitwiseExpr or b instanceof OrLogicalExpr) and
      result = left.booleanOr(right)
      or
      b instanceof XorBitwiseExpr and result = left.booleanXor(right)
    )
    or
    // Ternary expressions, where the `true` and `false` expressions are boolean constants.
    exists(ConditionalExpr ce, boolean condition |
      ce = e and
      condition = getBoolVal(ce.getCondition()) and
      result = getBoolVal(ce.getBranchExpr(condition))
    )
    or
    // If a `Variable` is final, its value is its initializer, if it exists.
    exists(Variable v | e = v.getAnAccess() and v.isFinal() |
      result = getBoolVal(v.getInitializer())
    )
  }

  /** Gets the value of a constant integer expression. */
  int calculateIntValue(Expr e) {
    exists(IntegralType t | e.getType() = t | t.getName().toLowerCase() != "long") and
    (
      exists(CastingExpr cast, int val | cast = e and val = getIntVal(cast.getExpr()) |
        if cast.getType().hasName("byte")
        then result = (val + 128).bitAnd(255) - 128
        else
          if cast.getType().hasName("short")
          then result = (val + 32768).bitAnd(65535) - 32768
          else
            if cast.getType().hasName("char")
            then result = val.bitAnd(65535)
            else result = val
      )
      or
      result = getIntVal(e.(PlusExpr).getExpr())
      or
      result = -getIntVal(e.(MinusExpr).getExpr())
      or
      result = getIntVal(e.(BitNotExpr).getExpr()).bitNot()
      or
      // No `int` value for `LogNotExpr`.
      exists(BinaryExpr b, int v1, int v2 |
        b = e and
        v1 = getIntVal(b.getLeftOperand()) and
        v2 = getIntVal(b.getRightOperand())
      |
        b instanceof MulExpr and result = v1 * v2
        or
        b instanceof DivExpr and result = v1 / v2
        or
        b instanceof RemExpr and result = v1 % v2
        or
        b instanceof AddExpr and result = v1 + v2
        or
        b instanceof SubExpr and result = v1 - v2
        or
        b instanceof LeftShiftExpr and result = v1.bitShiftLeft(v2)
        or
        b instanceof RightShiftExpr and result = v1.bitShiftRightSigned(v2)
        or
        b instanceof UnsignedRightShiftExpr and result = v1.bitShiftRight(v2)
        or
        b instanceof AndBitwiseExpr and result = v1.bitAnd(v2)
        or
        b instanceof OrBitwiseExpr and result = v1.bitOr(v2)
        or
        b instanceof XorBitwiseExpr and result = v1.bitXor(v2)
        // No `int` value for `AndLogicalExpr` or `OrLogicalExpr`.
        // No `int` value for `LTExpr`, `GTExpr`, `LEExpr`, `GEExpr`, `ValueOrReferenceEqualsExpr` or `ValueOrReferenceNotEqualsExpr`.
      )
      or
      // Ternary conditional, with constant condition.
      exists(ConditionalExpr ce, boolean condition |
        ce = e and
        condition = getBoolVal(ce.getCondition()) and
        result = getIntVal(ce.getBranchExpr(condition))
      )
      or
      // If a `Variable` is final, its value is its initializer, if it exists.
      exists(Variable v | e = v.getAnAccess() and v.isFinal() |
        result = getIntVal(v.getInitializer())
      )
    )
  }
}
