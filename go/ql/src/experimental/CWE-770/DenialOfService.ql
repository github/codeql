/**
 * @name Denial Of Service
 * @description slices created with the built-in make function from user-controlled sources using a
 * maliciously large value possibly leading to a denial of service.
 * @kind path-problem
 * @problem.severity high
 * @security-severity 9
 * @id go/denial-of-service
 * @tags security
 *       experimental
 *       external/cwe/cwe-770
 */

import go

class BuiltInMake extends DataFlow::Node {
  BuiltInMake() { this = Builtin::make().getACall().getArgument(0) }
}

/**
 * Holds if `g` is a barrier-guard which checks `e` is nonzero on `branch`.
 */
predicate denialOfServiceSanitizerGuard(DataFlow::Node g, Expr e, boolean branch) {
  exists(DataFlow::Node lesser |
    e = lesser.asExpr() and
    g.(DataFlow::RelationalComparisonNode).leq(branch, lesser, _, _)
  )
  or
  exists(LogicalBinaryExpr lbe, DataFlow::Node lesser |
    lbe.getAnOperand() = g.(DataFlow::RelationalComparisonNode).asExpr() and
    e = lesser.asExpr() and
    g.(DataFlow::RelationalComparisonNode).leq(branch, lesser, _, _)
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Function f, DataFlow::CallNode cn | cn = f.getACall() |
      f.hasQualifiedName("strconv", ["Atoi", "ParseInt", "ParseUint", "ParseFloat"]) and
      node1 = cn.getArgument(0) and
      node2 = cn.getResult(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<denialOfServiceSanitizerGuard/3>::getABarrierNode()
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof BuiltInMake }
}

/**
 * Tracks taint flow for reasoning about denial of service, where source is
 * user-controlled and unchecked.
 */
module Flow = TaintTracking::Global<Config>;

import Flow::PathGraph

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source, sink, "This variable might be leading to denial of service."
