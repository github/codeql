/**
 * @name Uncontrolled data in arithmetic expression
 * @description Arithmetic operations on uncontrolled data that is not
 *              validated can cause overflows.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.9
 * @precision medium
 * @id cpp/uncontrolled-arithmetic
 * @tags security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.security.Overflow
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import TaintedWithPath

predicate isUnboundedRandCall(FunctionCall fc) {
  exists(Function func | func = fc.getTarget() |
    func.hasGlobalOrStdOrBslName("rand") and
    not bounded(fc) and
    func.getNumberOfParameters() = 0
  )
}

/**
 * An operand `e` of a division expression (i.e., `e` is an operand of either a `DivExpr` or
 * a `AssignDivExpr`) is bounded when `e` is the left-hand side of the division.
 */
pragma[inline]
predicate boundedDiv(Expr e, Expr left) { e = left }

/**
 * An operand `e` of a remainder expression `rem` (i.e., `rem` is either a `RemExpr` or
 * an `AssignRemExpr`) with left-hand side `left` and right-ahnd side `right` is bounded
 * when `e` is `left` and `right` is upper bounded by some number that is less than the maximum integer
 * allowed by the result type of `rem`.
 */
pragma[inline]
predicate boundedRem(Expr e, Expr rem, Expr left, Expr right) {
  e = left and
  upperBound(right.getFullyConverted()) < exprMaxVal(rem.getFullyConverted())
}

/**
 * An operand `e` of a bitwise and expression `andExpr` (i.e., `andExpr` is either an `BitwiseAndExpr`
 * or an `AssignAndExpr`) with operands `operand1` and `operand2` is the operand that is not `e` is upper
 * bounded by some number that is less than the maximum integer allowed by the result type of `andExpr`.
 */
pragma[inline]
predicate boundedBitwiseAnd(Expr e, Expr andExpr, Expr operand1, Expr operand2) {
  operand1 != operand2 and
  e = operand1 and
  upperBound(operand2.getFullyConverted()) < exprMaxVal(andExpr.getFullyConverted())
}

/**
 * Holds if `fc` is a part of the left operand of a binary operation that greatly reduces the range
 * of possible values.
 */
predicate bounded(Expr e) {
  //  For `%` and `&` we require that `e` is bounded by a value that is strictly smaller than the
  //  maximum possible value of the result type of the operation.
  //  For example, the function call `rand()` is considered bounded in the following program:
  //  ```
  //  int i = rand() % (UINT8_MAX + 1);
  //  ```
  //  but not in:
  //  ```
  //  unsigned char uc = rand() % (UINT8_MAX + 1);
  //  ```
  exists(RemExpr rem | boundedRem(e, rem, rem.getLeftOperand(), rem.getRightOperand()))
  or
  exists(AssignRemExpr rem | boundedRem(e, rem, rem.getLValue(), rem.getRValue()))
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

predicate isUnboundedRandCallOrParent(Expr e) {
  isUnboundedRandCall(e)
  or
  isUnboundedRandCallOrParent(e.getAChild())
}

predicate isUnboundedRandValue(Expr e) {
  isUnboundedRandCall(e)
  or
  exists(MacroInvocation mi |
    e = mi.getExpr() and
    isUnboundedRandCallOrParent(e)
  )
}

class SecurityOptionsArith extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    isUnboundedRandValue(expr) and
    cause = "rand"
  }
}

predicate missingGuard(VariableAccess va, string effect) {
  exists(Operation op | op.getAnOperand() = va |
    missingGuardAgainstUnderflow(op, va) and effect = "underflow"
    or
    missingGuardAgainstOverflow(op, va) and effect = "overflow"
  )
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element e) { missingGuard(e, _) }

  override predicate isBarrier(Expr e) { super.isBarrier(e) or bounded(e) }
}

from Expr origin, VariableAccess va, string effect, PathNode sourceNode, PathNode sinkNode
where
  taintedWithPath(origin, va, sourceNode, sinkNode) and
  missingGuard(va, effect)
select va, sourceNode, sinkNode,
  "$@ flows to here and is used in arithmetic, potentially causing an " + effect + ".", origin,
  "Uncontrolled value"
