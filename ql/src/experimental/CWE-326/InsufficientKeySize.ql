/**
 * @name Use of a weak cryptographic key
 * @description Using weak cryptographic key can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @id go/weak-crypto-key
 * @tags security
 *         external/cwe/cwe-326
 */

import go
import DataFlow::PathGraph

class RsaKeyTrackingConfiguration extends DataFlow::Configuration {
  RsaKeyTrackingConfiguration() { this = "RsaKeyTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(ValueExpr c |
      source.asExpr() = c and
      c.getIntValue() < 2048
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr c |
      sink.asExpr() = c.getArgument(1) and
      c.getTarget().hasQualifiedName("crypto/rsa", "GenerateKey")
    )
  }
}

from RsaKeyTrackingConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "The size of RSA key '$@' should be at least 2048 bits.", sink,
  source.getNode().toString()
