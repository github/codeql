/**
 * @name Unsigned difference expression compared to zero
 * @description It is highly probable that the condition is wrong if the difference expression has the unsigned type.
 *              The condition holds in all the cases when difference is not equal to zero. It means that we may use condition not equal.
 *              But the programmer probably wanted to compare the difference of elements.
 * @kind problem
 * @id cpp/unsigned-difference-expression-compared-zero
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-191
 */

import cpp
import semmle.code.cpp.commons.Exclusions
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import semmle.code.cpp.controlflow.Guards

/** Holds if `sub` will never be nonnegative. */
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
  ro.getLesserOperand().getValue().toInt() = 0 and
  ro.getGreaterOperand() = sub and
  sub.getFullyConverted().getUnspecifiedType().(IntegralType).isUnsigned() and
  not nonNegative(sub)
select ro, "Difference in condition is always greater than or equal to zero"
