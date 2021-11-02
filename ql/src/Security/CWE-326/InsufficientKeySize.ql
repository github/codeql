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
import DataFlow::PathGraph

/**
 * RSA key length data flow tracking configuration.
 */
class RsaKeyTrackingConfiguration extends DataFlow::Configuration {
  RsaKeyTrackingConfiguration() { this = "RsaKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) { source.getIntValue() < 2048 }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode c |
      sink = c.getArgument(1) and
      c.getTarget().hasQualifiedName("crypto/rsa", "GenerateKey")
    )
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ComparisonBarrierGuard
  }
}

/**
 * A comparison which guarantees that an expression is at least 2048,
 * considered as a barrier guard for key sizes.
 */
class ComparisonBarrierGuard extends DataFlow::BarrierGuard instanceof DataFlow::RelationalComparisonNode {
  override predicate checks(Expr e, boolean branch) {
    exists(DataFlow::Node lesser, DataFlow::Node greater, int bias |
      super.leq(branch, lesser, greater, bias)
    |
      // Force join order: find comparisons checking x >= 2048, then take the global value
      // number of x. Otherwise this can be realised by starting from all pairs of matching value
      // numbers, which can be huge.
      pragma[only_bind_into](globalValueNumber(DataFlow::exprNode(e))) = globalValueNumber(greater) and
      lesser.getIntValue() - bias >= 2048
    )
  }
}

from RsaKeyTrackingConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "The size of this RSA key should be at least 2048 bits."
