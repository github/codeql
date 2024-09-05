/**
 * This file provides the `bounded` predicate that is used in `cpp/uncontrolled-arithmetic`,
 * `cpp/tainted-arithmetic` and `cpp/uncontrolled-allocation-size`.
 */

private import cpp
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * An operand `operand` of a bitwise and expression `andExpr` (i.e., `andExpr` is either a
 * `BitwiseAndExpr` or an `AssignAndExpr`) is upper bounded by some number that is less than the
 * maximum integer allowed by the result type of `andExpr`.
 */
pragma[inline]
private predicate boundedBitwiseAnd(Expr operand, Expr andExpr) {
  upperBound(operand.getFullyConverted()) < exprMaxVal(andExpr.getFullyConverted())
}

/**
 * Holds if `e` is an arithmetic expression that cannot overflow, or if `e` is an operation that
 * may greatly reduce the range of possible values.
 */
predicate bounded(Expr e) {
  // There can be two separate reasons for `convertedExprMightOverflow` not holding:
  // 1. `e` really cannot overflow.
  // 2. `e` isn't analyzable.
  // If we didn't rule out case 2 we would declare anything that isn't analyzable as bounded.
  (
    e instanceof UnaryArithmeticOperation or
    e instanceof BinaryArithmeticOperation or
    e instanceof AssignArithmeticOperation
  ) and
  not convertedExprMightOverflow(e)
  or
  // Optimistically assume that the following operations always yields a much smaller value.
  e instanceof RemExpr
  or
  e instanceof DivExpr
  or
  e instanceof RShiftExpr
  or
  exists(BitwiseAndExpr andExpr |
    e = andExpr and boundedBitwiseAnd(andExpr.getAnOperand(), andExpr)
  )
  or
  // For the assignment variant of the operations we place the barrier on the assigned lvalue.
  e = any(AssignRemExpr rem).getLValue()
  or
  e = any(AssignDivExpr div).getLValue()
  or
  e = any(AssignRShiftExpr div).getLValue()
  or
  exists(AssignAndExpr andExpr |
    e = andExpr.getLValue() and boundedBitwiseAnd(andExpr.getRValue(), andExpr)
  )
}
