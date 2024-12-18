/**
 * @name Unsigned difference expression compared to zero
 * @description A subtraction with an unsigned result can never be negative. Using such an expression in a relational comparison with `0` is likely to be wrong.
 * @kind problem
 * @id cpp/unsigned-difference-expression-compared-zero
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @tags security
 *       correctness
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 *  Holds if `sub` is guarded by a condition which ensures that
 * `left >= right`.
 */
pragma[nomagic]
predicate isGuarded(SubExpr sub, Expr left, Expr right) {
  exprIsSubLeftOrLess(pragma[only_bind_into](sub), _) and // Manual magic
  exists(GuardCondition guard, int k, BasicBlock bb |
    pragma[only_bind_into](bb) = sub.getBasicBlock() and
    guard.controls(pragma[only_bind_into](bb), _) and
    guard.ensuresLt(left, right, k, bb, false) and
    k >= 0
  )
}

/**
 * Gets an expression that is less than or equal to `sub.getLeftOperand()`.
 * These serve as the base cases for `exprIsSubLeftOrLess`.
 */
Expr exprIsLeftOrLessBase(SubExpr sub) {
  interestingSubExpr(sub, _) and // Manual magic
  exists(Expr e | globalValueNumber(e).getAnExpr() = sub.getLeftOperand() |
    // sub = e - x
    // result = e
    // so:
    // result <= e
    result = e
    or
    // sub = e - x
    // result = e & y
    // so:
    // result = e & y <= e
    result.(BitwiseAndExpr).getAnOperand() = e
    or
    exists(SubExpr s |
      // sub = e - x
      // result = s
      // s = e - y
      // y >= 0
      // so:
      // result = e - y <= e
      result = s and
      s.getLeftOperand() = e and
      lowerBound(s.getRightOperand().getFullyConverted()) >= 0
    )
    or
    exists(Expr other |
      // sub = e - x
      // result = a
      // a = e + y
      // y <= 0
      // so:
      // result = e + y <= e + 0 = e
      result.(AddExpr).hasOperands(e, other) and
      upperBound(other.getFullyConverted()) <= 0
    )
    or
    exists(DivExpr d |
      // sub = e - x
      // result = d
      // d = e / y
      // y >= 1
      // so:
      // result = e / y <= e / 1 = e
      result = d and
      d.getLeftOperand() = e and
      lowerBound(d.getRightOperand().getFullyConverted()) >= 1
    )
    or
    exists(RShiftExpr rs |
      // sub = e - x
      // result = rs
      // rs = e >> y
      // so:
      // result = e >> y <= e
      result = rs and
      rs.getLeftOperand() = e
    )
  )
}

/**
 * Holds if `n` is known or suspected to be less than or equal to
 * `sub.getLeftOperand()`.
 */
predicate exprIsSubLeftOrLess(SubExpr sub, DataFlow::Node n) {
  n.asExpr() = exprIsLeftOrLessBase(sub)
  or
  exists(DataFlow::Node other |
    // dataflow
    exprIsSubLeftOrLess(sub, other) and
    (
      DataFlow::localFlowStep(n, other) or
      DataFlow::localFlowStep(other, n)
    )
  )
  or
  exists(DataFlow::Node other |
    // guard constraining `sub`
    exprIsSubLeftOrLess(sub, other) and
    isGuarded(sub, other.asExpr(), n.asExpr()) // other >= n
  )
  or
  exists(DataFlow::Node other, float p, float q |
    // linear access of `other`
    exprIsSubLeftOrLess(sub, other) and
    linearAccess(n.asExpr(), other.asExpr(), p, q) and // n = p * other + q
    p <= 1 and
    q <= 0
  )
  or
  exists(DataFlow::Node other, float p, float q |
    // linear access of `n`
    exprIsSubLeftOrLess(sub, other) and
    linearAccess(other.asExpr(), n.asExpr(), p, q) and // other = p * n + q
    p >= 1 and
    q >= 0
  )
}

predicate interestingSubExpr(SubExpr sub, RelationalOperation ro) {
  not isFromMacroDefinition(sub) and
  ro.getLesserOperand().getValue().toInt() = 0 and
  ro.getGreaterOperand() = sub and
  sub.getFullyConverted().getUnspecifiedType().(IntegralType).isUnsigned() and
  // generally catches false positives involving constants
  exprMightOverflowNegatively(sub.getFullyConverted())
}

from RelationalOperation ro, SubExpr sub
where
  interestingSubExpr(sub, ro) and
  not isFromMacroDefinition(ro) and
  // generally catches false positives where there's a relation between the left and right operands
  not exprIsSubLeftOrLess(sub, DataFlow::exprNode(sub.getRightOperand()))
select ro, "Unsigned subtraction can never be negative."
