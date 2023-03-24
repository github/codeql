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
import DataFlow::PathGraph
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

/**
 * A taint-tracking configuration for reasoning about division by zero, where divisor is user-controlled and unchecked.
 */
class DivideByZeroCheckConfig extends TaintTracking::Configuration {
  DivideByZeroCheckConfig() { this = "DivideByZeroCheckConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Function f, DataFlow::CallNode cn | cn = f.getACall() |
      f.hasQualifiedName("strconv", ["Atoi", "ParseInt", "ParseUint", "ParseFloat"]) and
      pred = cn.getArgument(0) and
      succ = cn.getResult(0)
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<divideByZeroSanitizerGuard/3>::getABarrierNode()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = DataFlow::exprNode(any(QuoExpr e).getRightOperand())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, DivideByZeroCheckConfig cfg
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "This variable might be zero leading to a division-by-zero panic."
