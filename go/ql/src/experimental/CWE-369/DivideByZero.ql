/**
 * @name Divide by zero
 * @description Dividing an integer by a user-controlled value may lead to division by zero and an unexpected panic.
 * @kind path-problem
 * @problem.severity error
 * @id go/divide-by-zero
 * @tags security
 *       experimental
 *       external/cwe/cwe-369
 */

import go
import semmle.go.dataflow.internal.TaintTrackingUtil

/**
 * Holds if `g` is a barrier-guard which checks `e` is nonzero on `branch`.
 */
predicate divideByZeroSanitizerGuard(DataFlow::Node g, Expr e, boolean branch) {
  exists(DataFlow::Node zero, DataFlow::Node checked |
    zero.getNumericValue() = 0 and
    e = checked.asExpr() and
    checked.getType().getUnderlyingType() instanceof IntegerType and
    (
      g.(DataFlow::EqualityTestNode).eq(branch.booleanNot(), checked, zero) or
      g.(DataFlow::RelationalComparisonNode).leq(branch.booleanNot(), checked, zero, 0)
    )
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Function f, DataFlow::CallNode cn | cn = f.getACall() |
      f.hasQualifiedName("strconv", ["Atoi", "ParseInt", "ParseUint", "ParseFloat"]) and
      node1 = cn.getArgument(0) and
      node2 = cn.getResult(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<divideByZeroSanitizerGuard/3>::getABarrierNode()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = DataFlow::exprNode(any(QuoExpr e).getRightOperand())
  }
}

/**
 * Tracks taint flow for reasoning about division by zero, where divisor is
 * user-controlled and unchecked.
 */
module Flow = TaintTracking::Global<Config>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source, sink, "This variable might be zero leading to a division-by-zero panic."
