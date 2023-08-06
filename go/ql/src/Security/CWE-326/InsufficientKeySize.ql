/**
 * @name Use of a weak cryptographic key
 * @description Using a weak cryptographic key can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id go/weak-crypto-key
 * @tags security
 *       external/cwe/cwe-326
 */

import go

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.getIntValue() < 2048 }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode c |
      sink = c.getArgument(1) and
      c.getTarget().hasQualifiedName("crypto/rsa", "GenerateKey")
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<comparisonBarrierGuard/3>::getABarrierNode()
  }
}

/**
 * Tracks data flow from an RSA key length to a calls to an RSA key generation
 * function.
 */
module Flow = DataFlow::Global<Config>;

import Flow::PathGraph

/**
 * Holds if `g` is a comparison which guarantees that `e` is at least 2048 on `branch`,
 * considered as a barrier guard for key sizes.
 */
predicate comparisonBarrierGuard(DataFlow::Node g, Expr e, boolean branch) {
  exists(DataFlow::Node lesser, DataFlow::Node greater, int bias |
    g.(DataFlow::RelationalComparisonNode).leq(branch, lesser, greater, bias)
  |
    // Force join order: find comparisons checking x >= 2048, then take the global value
    // number of x. Otherwise this can be realised by starting from all pairs of matching value
    // numbers, which can be huge.
    pragma[only_bind_into](globalValueNumber(DataFlow::exprNode(e))) = globalValueNumber(greater) and
    lesser.getIntValue() - bias >= 2048
  )
}

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink, source, sink, "The size of this RSA key should be at least 2048 bits."
