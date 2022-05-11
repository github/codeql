/**
 * @name Operator Precedence Logic Error When Use Bitwise Or Logical Operations
 * @description --Finding places to use bit and logical operations, without explicit priority allocation.
 *              --For example, `a || b ^ c` and `(a || b) ^ c` give different results when `b` is zero.
 * @kind problem
 * @id cpp/operator-precedence-logic-error-when-use-bitwise-logical-operations
 * @problem.severity recommendation
 * @precision medium
 * @tags maintainability
 *       readability
 *       external/cwe/cwe-783
 *       external/cwe/cwe-480
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/** Holds if `exptmp` equals expression logical or followed by logical and. */
predicate isLogicalOrAndExpr(LogicalOrExpr exptmp) {
  not exptmp.getLeftOperand() instanceof BinaryOperation and
  not exptmp.getRightOperand().isParenthesised() and
  exptmp.getRightOperand() instanceof LogicalAndExpr
}

/** Holds if `exptmp` equals expression logical or followed by bit operation. */
predicate isLogicalOrandBitwise(Expr exptmp) {
  not exptmp.(LogicalOrExpr).getLeftOperand() instanceof BinaryOperation and
  not exptmp.(LogicalOrExpr).getRightOperand().isParenthesised() and
  (
    exptmp.(LogicalOrExpr).getRightOperand().(BinaryBitwiseOperation).getLeftOperand().getType()
      instanceof BoolType and
    // The essence of these lines is to improve the quality of detection by eliminating the situation
    // of processing a logical type by bit operations. In fact, the predicate looks for a situation
    // when the left operand of a bit operation has a boolean type, which already suggests that the priority is not correct.
    // But if the right-hand operand is 0 or 1, then there is a possibility that the author intended so.
    not exptmp
        .(LogicalOrExpr)
        .getRightOperand()
        .(BinaryBitwiseOperation)
        .getRightOperand()
        .getValue() = "0" and
    not exptmp
        .(LogicalOrExpr)
        .getRightOperand()
        .(BinaryBitwiseOperation)
        .getRightOperand()
        .getValue() = "1"
  )
  or
  not exptmp.(LogicalAndExpr).getLeftOperand() instanceof BinaryOperation and
  not exptmp.(LogicalAndExpr).getRightOperand().isParenthesised() and
  (
    exptmp.(LogicalAndExpr).getRightOperand().(BinaryBitwiseOperation).getLeftOperand().getType()
      instanceof BoolType and
    // Looking for a situation in which the right-hand operand of a bit operation is not limited to 0 or 1.
    // In this case, the logical operation will be performed with the result of a binary operation that is not a Boolean type.
    // In my opinion this indicates a priority error. after all, it will be quite difficult for a developer
    // to evaluate the conversion of the results of a bit operation to a boolean type.
    not exptmp
        .(LogicalAndExpr)
        .getRightOperand()
        .(BinaryBitwiseOperation)
        .getRightOperand()
        .getValue() = "0" and
    not exptmp
        .(LogicalAndExpr)
        .getRightOperand()
        .(BinaryBitwiseOperation)
        .getRightOperand()
        .getValue() = "1"
  )
}

/** Holds if `exptmp` equals expression bit operations in reverse priority order. */
predicate isBitwiseandBitwise(Expr exptmp) {
  not exptmp.(BitwiseOrExpr).getLeftOperand() instanceof BinaryOperation and
  not exptmp.(BitwiseOrExpr).getRightOperand().isParenthesised() and
  (
    exptmp.(BitwiseOrExpr).getRightOperand() instanceof BitwiseAndExpr or
    exptmp.(BitwiseOrExpr).getRightOperand() instanceof BitwiseXorExpr
  )
  or
  not exptmp.(BitwiseXorExpr).getLeftOperand() instanceof BinaryOperation and
  not exptmp.(BitwiseXorExpr).getRightOperand().isParenthesised() and
  exptmp.(BitwiseXorExpr).getRightOperand() instanceof BitwiseAndExpr
}

/** Holds if the range contains no boundary values. */
predicate isRealRange(Expr exp) {
  upperBound(exp).toString() != "18446744073709551616" and
  upperBound(exp).toString() != "9223372036854775807" and
  upperBound(exp).toString() != "4294967295" and
  upperBound(exp).toString() != "Infinity" and
  upperBound(exp).toString() != "NaN" and
  lowerBound(exp).toString() != "-9223372036854775808" and
  lowerBound(exp).toString() != "-4294967296" and
  lowerBound(exp).toString() != "-Infinity" and
  lowerBound(exp).toString() != "NaN" and
  upperBound(exp) != 2147483647 and
  upperBound(exp) != 268435455 and
  upperBound(exp) != 33554431 and
  upperBound(exp) != 8388607 and
  upperBound(exp) != 65535 and
  upperBound(exp) != 32767 and
  upperBound(exp) != 255 and
  upperBound(exp) != 127 and
  lowerBound(exp) != -2147483648 and
  lowerBound(exp) != -268435456 and
  lowerBound(exp) != -33554432 and
  lowerBound(exp) != -8388608 and
  lowerBound(exp) != -65536 and
  lowerBound(exp) != -32768 and
  lowerBound(exp) != -128
  or
  lowerBound(exp) = 0 and
  upperBound(exp) = 1
}

/** Holds if expressions are of different size or range */
pragma[inline]
predicate isDifferentSize(Expr exp1, Expr exp2, Expr exp3) {
  exp1.getType().getSize() = exp2.getType().getSize() and
  exp1.getType().getSize() != exp3.getType().getSize()
  or
  (
    isRealRange(exp1) and
    isRealRange(exp2) and
    isRealRange(exp3)
  ) and
  upperBound(exp1).maximum(upperBound(exp2)) - upperBound(exp1).minimum(upperBound(exp2)) < 16 and
  lowerBound(exp1).maximum(lowerBound(exp2)) - lowerBound(exp1).minimum(lowerBound(exp2)) < 16 and
  (
    upperBound(exp1).maximum(upperBound(exp3)) - upperBound(exp1).minimum(upperBound(exp3)) > 256 or
    lowerBound(exp1).maximum(lowerBound(exp2)) - lowerBound(exp1).minimum(lowerBound(exp2)) > 256
  )
}

/** Holds if different values of the expression obtained from the parameters of the predicate can be obtained. */
pragma[inline]
predicate isDifferentResults(
  Expr exp1, Expr exp2, Expr exp3, BinaryBitwiseOperation op1, BinaryBitwiseOperation op2
) {
  (
    isRealRange(exp1) and
    isRealRange(exp2) and
    isRealRange(exp3)
  ) and
  exists(int i1, int i2, int i3 |
    i1 in [lowerBound(exp1).floor() .. upperBound(exp1).floor()] and
    i2 in [lowerBound(exp2).floor() .. upperBound(exp2).floor()] and
    i3 in [lowerBound(exp3).floor() .. upperBound(exp3).floor()] and
    (
      op1 instanceof BitwiseOrExpr and
      op2 instanceof BitwiseAndExpr and
      i1.bitOr(i2).bitAnd(i3) != i2.bitAnd(i3).bitOr(i1)
      or
      op1 instanceof BitwiseOrExpr and
      op2 instanceof BitwiseXorExpr and
      i1.bitOr(i2).bitXor(i3) != i2.bitXor(i3).bitOr(i1)
      or
      op1 instanceof BitwiseXorExpr and
      op2 instanceof BitwiseAndExpr and
      i1.bitXor(i2).bitAnd(i3) != i2.bitAnd(i3).bitXor(i1)
    )
  )
}

from Expr exp, string msg
where
  isLogicalOrAndExpr(exp) and
  msg = "Logical AND has a higher priority."
  or
  isLogicalOrandBitwise(exp) and
  msg = "Binary operations have higher priority."
  or
  // Looking for a situation where the equality of the sizes of the first operands
  // might indicate that the developer planned to perform an operation between them.
  // However, the absence of parentheses means that the rightmost operation will be performed initially.
  isBitwiseandBitwise(exp) and
  isDifferentSize(exp.(BinaryBitwiseOperation).getLeftOperand(),
    exp.(BinaryBitwiseOperation).getRightOperand().(BinaryBitwiseOperation).getLeftOperand(),
    exp.(BinaryBitwiseOperation).getRightOperand().(BinaryBitwiseOperation).getRightOperand()) and
  msg = "Expression ranges do not match operation precedence."
  or
  // Looking for a out those expressions that, as a result of identifying the priority with parentheses,
  // will give different values. As a consequence, this piece of code was supposed to find errors associated
  // with possible outcomes of operations.
  isBitwiseandBitwise(exp) and
  isDifferentResults(exp.(BinaryBitwiseOperation).getLeftOperand(),
    exp.(BinaryBitwiseOperation).getRightOperand().(BinaryBitwiseOperation).getLeftOperand(),
    exp.(BinaryBitwiseOperation).getRightOperand().(BinaryBitwiseOperation).getRightOperand(), exp,
    exp.(BinaryBitwiseOperation).getRightOperand()) and
  msg = "specify the priority with parentheses."
select exp, msg
