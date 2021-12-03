/**
 * Provides the implementation of the BadAdditionOverflowCheck query. The
 * query is implemented as a library, so that we can avoid producing
 * duplicate results in other similar queries.
 */

import cpp
private import semmle.code.cpp.rangeanalysis.RangeAnalysisUtils

/**
 * Holds if `a` and `b` are the operands of `plus`. This predicate
 * simplifies the pattern matching logic in `badAdditionOverflowCheck` by
 * swapping the operands both ways round.
 */
private predicate addExpr(AddExpr plus, Expr a, Expr b) {
  a = plus.getLeftOperand() and b = plus.getRightOperand()
  or
  b = plus.getLeftOperand() and a = plus.getRightOperand()
}

/**
 * Holds if `cmp` is an overflow check of the following form:
 *
 *     a + b < a
 *
 * This check does not work if the operands of `a` and `b` are
 * automatically promoted to a larger type. If
 * `convertedExprMightOverflow(a)` does not hold, then it is impossible for
 * the addition to overflow, so the result of the comparison will always be
 * false.
 */
predicate badAdditionOverflowCheck(RelationalOperation cmp, AddExpr plus) {
  exists(Variable v, VariableAccess a1, VariableAccess a2, Expr b |
    addExpr(plus, a1, b) and
    a1 = v.getAnAccess() and
    a2 = v.getAnAccess() and
    not exists(a1.getQualifier()) and // Avoid structure fields
    not exists(a2.getQualifier()) and // Avoid structure fields
    // Simple type-based check that the addition cannot overflow.
    exprMinVal(plus) <= exprMinVal(a1) + exprMinVal(b) and
    exprMaxVal(plus) > exprMaxVal(a1) and
    exprMaxVal(plus) > exprMaxVal(b) and
    // Make sure that the plus isn't explicitly cast to a smaller type.
    exprMinVal(plus.getExplicitlyConverted()) <= exprMinVal(plus) and
    exprMaxVal(plus.getExplicitlyConverted()) >= exprMaxVal(plus) and
    cmp.getAnOperand() = plus and
    cmp.getAnOperand() = a2
  )
}
