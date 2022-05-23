/**
 * @name Use of a weak cryptographic algorithm
 * @description Using weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @id go/weak-crypto-algorithm
 * @tags security
 *         external/cwe/cwe-327
 *         external/cwe/cwe-328
 */

import go
import WeakCryptoAlgorithmCustomizations::WeakCryptoAlgorithm
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is used in a weak cryptographic algorithm.",
  source.getNode(), "Sensitive data"
