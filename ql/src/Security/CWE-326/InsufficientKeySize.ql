/**
 * @name Use of a weak cryptographic key
 * @description Using weak cryptographic key can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id go/weak-crypto-key
 * @tags security
 *         external/cwe/cwe-326
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
}

from RsaKeyTrackingConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "The size of this RSA key should be at least 2048 bits."
