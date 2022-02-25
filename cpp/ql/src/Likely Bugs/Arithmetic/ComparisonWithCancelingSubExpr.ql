/**
 * @name Comparison with canceling sub-expression
 * @description If the same sub-expression is added to both sides of a
 *              comparison, and there is no possibility of overflow or
 *              rounding, then the sub-expression is redundant and could be
 *              removed.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id cpp/comparison-canceling-subexpr
 * @tags readability
 *       maintainability
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis
import BadAdditionOverflowCheck
import PointlessSelfComparison

/**
 * Holds if `parent` is a linear expression of `child`. For example:
 *
 *     `parent = child + E`
 *     `parent = E - child`
 *     `parent = 2 * child`
 */
private predicate linearChild(Expr parent, Expr child, float multiplier) {
  child = parent.(AddExpr).getAChild() and multiplier = 1.0
  or
  child = parent.(SubExpr).getLeftOperand() and multiplier = 1.0
  or
  child = parent.(SubExpr).getRightOperand() and multiplier = -1.0
  or
  child = parent.(UnaryPlusExpr).getOperand() and multiplier = 1.0
  or
  child = parent.(UnaryMinusExpr).getOperand() and multiplier = -1.0
}

/**
 * Holds if `child` is a linear sub-expression of `cmp`, and `multiplier`
 * is its multiplication factor. For example:
 *
 *     `4*x - y < 3*z`
 *
 * In this example, `x` has multiplier 4, `y` has multiplier -1, and `z`
 * has multiplier -3 (multipliers from the right hand child are negated).
 */
private predicate cmpLinearSubExpr(ComparisonOperation cmp, Expr child, float multiplier) {
  not convertedExprMightOverflow(child) and
  (
    child = cmp.getLeftOperand() and multiplier = 1.0
    or
    child = cmp.getRightOperand() and multiplier = -1.0
    or
    exists(Expr parent, float m1, float m2 |
      cmpLinearSubExpr(cmp, parent, m1) and
      linearChild(parent, child, m2) and
      multiplier = m1 * m2
    )
  )
}

/**
 * Holds if `cmpLinearSubExpr(cmp, child, multiplier)` holds and
 * `child` is an access of variable `v`.
 */
private predicate cmpLinearSubVariable(
  ComparisonOperation cmp, Variable v, VariableAccess child, float multiplier
) {
  v = child.getTarget() and
  not exists(child.getQualifier()) and
  cmpLinearSubExpr(cmp, child, multiplier)
}

/**
 * Holds if there are two linear sub-expressions of `cmp` that
 * cancel each other. For example, `v` can be cancelled in each of
 * these examples:
 *
 *     `v < v`
 *     `v + x - v < y`
 *     `v + x + v < y + 2*v`
 */
private predicate cancelingSubExprs(ComparisonOperation cmp, VariableAccess a1, VariableAccess a2) {
  exists(Variable v |
    exists(float m | m < 0 and cmpLinearSubVariable(cmp, v, a1, m)) and
    exists(float m | m > 0 and cmpLinearSubVariable(cmp, v, a2, m))
  ) and
  not any(ClassTemplateInstantiation inst).getATemplateArgument() = cmp.getParent*()
}

from ComparisonOperation cmp, VariableAccess a1, VariableAccess a2
where
  cancelingSubExprs(cmp, a1, a2) and
  // Most practical examples found by this query are instances of
  // BadAdditionOverflowCheck or PointlessSelfComparison.
  not badAdditionOverflowCheck(cmp, _) and
  not pointlessSelfComparison(cmp)
select cmp, "Comparison can be simplified by canceling $@ with $@.", a1, a1.getTarget().getName(),
  a2, a2.getTarget().getName()
