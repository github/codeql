/**
 * This file provides the `bounded` predicate that is used in both `cpp/uncontrolled-arithmetic`
 * and `cpp/tainted-arithmetic`.
 */

private import cpp
private import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * An operand `e` of a division expression (i.e., `e` is an operand of either a `DivExpr` or
 * a `AssignDivExpr`) is bounded when `e` is the left-hand side of the division.
 */
pragma[inline]
private predicate boundedDiv(Expr e, Expr left) { e = left }

/**
 * An operand `e` of a remainder expression (i.e., `e` is an operand of either a `RemExpr` or
 * a `AssignRemExpr`) is bounded when `e` is the left-hand side of the remainder.
 */
pragma[inline]
private predicate boundedRem(Expr e, Expr left) { e = left }

/**
 * An operand `e` of a bitwise and expression `andExpr` (i.e., `andExpr` is either an `BitwiseAndExpr`
 * or an `AssignAndExpr`) with operands `operand1` and `operand2` is the operand that is not `e` is upper
 * bounded by some number that is less than the maximum integer allowed by the result type of `andExpr`.
 */
pragma[inline]
private predicate boundedBitwiseAnd(Expr e, Expr andExpr, Expr operand1, Expr operand2) {
  operand1 != operand2 and
  e = operand1 and
  upperBound(operand2.getFullyConverted()) < exprMaxVal(andExpr.getFullyConverted())
}

/**
 * Holds if `e` is an arithmetic expression that cannot overflow, or if `e` is an operand of an
 * operation that may greatly reduce the range of possible values.
 */
predicate bounded(Expr e) {
  (
    e instanceof UnaryArithmeticOperation or
    e instanceof BinaryArithmeticOperation or
    e instanceof AssignArithmeticOperation
  ) and
  not convertedExprMightOverflow(e)
  or
  boundedRem(e, any(RemExpr rem).getLeftOperand())
  or
  boundedRem(e, any(AssignRemExpr rem).getLValue())
  or
  exists(BitwiseAndExpr andExpr |
    boundedBitwiseAnd(e, andExpr, andExpr.getAnOperand(), andExpr.getAnOperand())
  )
  or
  exists(AssignAndExpr andExpr |
    boundedBitwiseAnd(e, andExpr, andExpr.getAnOperand(), andExpr.getAnOperand())
  )
  or
  // Optimitically assume that a division always yields a much smaller value.
  boundedDiv(e, any(DivExpr div).getLeftOperand())
  or
  boundedDiv(e, any(AssignDivExpr div).getLValue())
  or
  boundedDiv(e, any(RShiftExpr shift).getLeftOperand())
  or
  boundedDiv(e, any(AssignRShiftExpr div).getLValue())
}
