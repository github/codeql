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
  forex(ControlFlow::Node cfn | cfn = e.getAControlFlowNode() |
    positive(cfn) or strictlyPositive(cfn)
  )
}

/** Holds if `e` can be negative and cannot be positive. */
predicate negativeExpr(Expr e) {
  forex(ControlFlow::Node cfn | cfn = e.getAControlFlowNode() |
    negative(cfn) or strictlyNegative(cfn)
  )
}

/** Holds if `e` is strictly positive. */
predicate strictlyPositiveExpr(Expr e) {
  forex(ControlFlow::Node cfn | cfn = e.getAControlFlowNode() | strictlyPositive(cfn))
}

/** Holds if `e` is strictly negative. */
predicate strictlyNegativeExpr(Expr e) {
  forex(ControlFlow::Node cfn | cfn = e.getAControlFlowNode() | strictlyNegative(cfn))
}

/** Holds if `e` can be positive and cannot be negative. */
predicate positive(ControlFlow::Nodes::ExprNode e) { Common::positive(e) }

/** Holds if `e` can be negative and cannot be positive. */
predicate negative(ControlFlow::Nodes::ExprNode e) { Common::negative(e) }

/** Holds if `e` is strictly positive. */
predicate strictlyPositive(ControlFlow::Nodes::ExprNode e) { Common::strictlyPositive(e) }

/** Holds if `e` is strictly negative. */
predicate strictlyNegative(ControlFlow::Nodes::ExprNode e) { Common::strictlyNegative(e) }
