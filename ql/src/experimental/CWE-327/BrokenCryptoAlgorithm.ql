/**
 * @name Use of a broken or risky cryptographic algorithm
 * @description Using broken or weak cryptographic algorithms can allow an attacker to compromise security.
 * @kind problem
 * @problem.severity error
 * @id go/weak-cryptographic-algorithm
 * @tags security
 */

import go
import BrokenCryptoAlgorithmCustomizations::BrokenCryptoAlgorithm

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), "Sensitive data is used in a broken or weak cryptographic algorithm."
