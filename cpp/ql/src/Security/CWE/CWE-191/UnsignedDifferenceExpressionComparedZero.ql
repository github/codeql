/**
 * @name Unsigned difference expression compared to zero
 * @description A subtraction with an unsigned result can never be negative. Using such an expression in a relational comparison with `0` is likely to be wrong.
 * @kind problem
 * @id cpp/unsigned-difference-expression-compared-zero
 * @problem.severity warning
 * @security-severity 9.8
 * @precision medium
 * @tags security
 *       correctness
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.dataflow.DataFlow

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
 * Holds if `n` is known or suspected to be less than or equal to
 * `sub.getLeftOperand()`.
 */
predicate exprIsSubLeftOrLess(SubExpr sub, DataFlow::Node n) {
  interestingSubExpr(sub, _) and // Manual magic
  (
    n.asExpr() = sub.getLeftOperand()
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
