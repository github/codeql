/**
 * Provides sign analysis to determine whether expression are always positive
 * or negative.
 *
 * The analysis is implemented as an abstract interpretation over the
 * three-valued domain `{negative, zero, positive}`.
 */

import csharp
private import semmle.code.csharp.dataflow.internal.rangeanalysis.SignAnalysisCommon as Common

/** Holds if `e` can be positive and cannot be negative. */
predicate positiveExpr(Expr e) {
  exists(ControlFlowNode cfn | cfn = e.getControlFlowNode() |
    positive(cfn) or strictlyPositive(cfn)
  )
}

/** Holds if `e` can be negative and cannot be positive. */
predicate negativeExpr(Expr e) {
  exists(ControlFlowNode cfn | cfn = e.getControlFlowNode() |
    negative(cfn) or strictlyNegative(cfn)
  )
}

/** Holds if `e` is strictly positive. */
predicate strictlyPositiveExpr(Expr e) { strictlyPositive(e.getControlFlowNode()) }

/** Holds if `e` is strictly negative. */
predicate strictlyNegativeExpr(Expr e) { strictlyNegative(e.getControlFlowNode()) }

/** Holds if `e` can be positive and cannot be negative. */
predicate positive(ControlFlowNodes::ExprNode e) { Common::positive(e) }

/** Holds if `e` can be negative and cannot be positive. */
predicate negative(ControlFlowNodes::ExprNode e) { Common::negative(e) }

/** Holds if `e` is strictly positive. */
predicate strictlyPositive(ControlFlowNodes::ExprNode e) { Common::strictlyPositive(e) }

/** Holds if `e` is strictly negative. */
predicate strictlyNegative(ControlFlowNodes::ExprNode e) { Common::strictlyNegative(e) }
