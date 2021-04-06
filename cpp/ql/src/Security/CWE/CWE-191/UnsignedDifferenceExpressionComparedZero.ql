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
import semmle.code.cpp.controlflow.Guards

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
}

from RelationalOperation ro, SubExpr sub
where
  not isFromMacroDefinition(ro) and
  not isFromMacroDefinition(sub) and
  ro.getLesserOperand().getValue().toInt() = 0 and
  ro.getGreaterOperand() = sub and
  sub.getFullyConverted().getUnspecifiedType().(IntegralType).isUnsigned() and
  not exprIsSubLeftOrLess(sub, sub.getRightOperand())
select ro, "Unsigned subtraction can never be negative."
