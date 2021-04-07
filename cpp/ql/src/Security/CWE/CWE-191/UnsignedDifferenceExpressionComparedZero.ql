/**
 * @name Unsigned difference expression compared to zero
 * @description A subtraction with an unsigned result can never be negative. Using such an expression in a relational comparison with `0` is likely to be wrong.
 * @kind problem
 * @id cpp/unsigned-difference-expression-compared-zero
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       correctness
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.ir.IR
import experimental.semmle.code.cpp.rangeanalysis.RangeAnalysis

/**
 *  Holds if `sub` is guarded by a condition which ensures that
 * `left >= right`.
 */
pragma[noinline]
predicate isGuarded(SubExpr sub, Expr left, Expr right) {
  exists(GuardCondition guard, int k |
    guard.controls(sub.getBasicBlock(), _) and
    guard.ensuresLt(left, right, k, sub.getBasicBlock(), false) and
    k >= 0
  )
}

/**
 * Holds if `e` is known to be less than or equal to `sub.getLeftOperand()`.
 */
predicate exprIsSubLeftOrLess(SubExpr sub, Expr e) {
  e = sub.getLeftOperand()
  or
  exists(Expr other |
    // GVN equality
    exprIsSubLeftOrLess(sub, other) and
    globalValueNumber(e) = globalValueNumber(other)
  )
  or
  exists(Expr other |
    // guard constraining `sub`
    exprIsSubLeftOrLess(sub, other) and
    isGuarded(sub, other, e) // left >= right
  )
  or
  exists(Expr other, float p, float q |
    // linear access of `other`
    exprIsSubLeftOrLess(sub, other) and
    linearAccess(e, other, p, q) and // e = p * other + q
    p <= 1 and
    q <= 0
  )
  or
  exists(Expr other, float p, float q |
    // linear access of `e`
    exprIsSubLeftOrLess(sub, other) and
    linearAccess(other, e, p, q) and // other = p * e + q
    p >= 1 and
    q >= 0
  )
}

predicate subIsSafe(SubExpr sub) {
  // RangeAnalysis shows `left >= right`.
  exists(Instruction i, LeftOperand left, RightOperand right, Bound b, int delta |
    i.getAST() = sub and
    left = i.getAnOperand() and
    right = i.getAnOperand() and
    boundedOperand(left, b, delta, false, _) and // left >= b + delta
    delta >= 0 and
    (
      b.getInstruction() = right.getAnyDef() or // b = right
      b instanceof ZeroBound // b = 0
    )
  )
  or
  exists(Instruction i, LeftOperand left, RightOperand right, Bound b, int delta |
    i.getAST() = sub and
    left = i.getAnOperand() and
    right = i.getAnOperand() and
    boundedOperand(right, b, delta, true, _) and // right <= b + delta
    delta <= 0 and
    (
      b.getInstruction() = left.getAnyDef() or // b = left
      b instanceof ZeroBound // b = 0
    )
  )
}

from RelationalOperation ro, SubExpr sub
where
  not isFromMacroDefinition(ro) and
  not isFromMacroDefinition(sub) and
  ro.getLesserOperand().getValue().toInt() = 0 and
  ro.getGreaterOperand() = sub and
  sub.getFullyConverted().getUnspecifiedType().(IntegralType).isUnsigned() and
  exprMightOverflowNegatively(sub.getFullyConverted()) and // generally catches false positives involving constants
  not exprIsSubLeftOrLess(sub, sub.getRightOperand()) and // generally catches false positives where there's a relation between the left and right operands
  not subIsSafe(sub)
select ro, "Unsigned subtraction can never be negative."
