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

/** Holds if `sub` will never be negative. */
predicate nonNegative(SubExpr sub) {
  not exprMightOverflowNegatively(sub.getFullyConverted())
  or
  // The subtraction is guarded by a check of the form `left >= right`.
  exists(GuardCondition guard, Expr left, Expr right |
    left = globalValueNumber(sub.getLeftOperand()).getAnExpr() and
    right = globalValueNumber(sub.getRightOperand()).getAnExpr() and
    guard.controls(sub.getBasicBlock(), true) and
    guard.ensuresLt(left, right, 0, sub.getBasicBlock(), false)
  )
}

from RelationalOperation ro, SubExpr sub
where
  not isFromMacroDefinition(ro) and
  not isFromMacroDefinition(sub) and
  ro.getLesserOperand().getValue().toInt() = 0 and
  ro.getGreaterOperand() = sub and
  sub.getFullyConverted().getUnspecifiedType().(IntegralType).isUnsigned() and
  not nonNegative(sub)
select ro, "Unsigned subtraction can never be negative."
