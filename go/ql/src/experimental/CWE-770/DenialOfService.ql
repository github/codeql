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


/**
 * Holds if the guard `g` on its branch `branch` checks that `e` is not constant and is less than some other value.
 */
predicate denialOfServiceSanitizerGuard(DataFlow::Node g, Expr e, boolean branch) {
  exists(DataFlow::Node lesser |
    e = lesser.asExpr() and
    g.(DataFlow::RelationalComparisonNode).leq(branch, lesser, _, _) and
    not e.isConst()
  )
}

/*
 * Module for defining predicates and tracking taint flow related to denial of service issues.
 */
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

  predicate isSink(DataFlow::Node sink) { sink = Builtin::make().getACall().getArgument(0) }
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
