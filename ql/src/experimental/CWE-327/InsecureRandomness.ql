/**
 * @name Use of insufficient randomness as the key of a cryptographic algorithm
 * @description Using insufficient randomness as the key of a cryptographic algorithm can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @id go/insecure-randomness
 * @tags security
 *      external/cwe/cwe-327
 */

import go
import InsecureRandomnessCustomizations::InsecureRandomness
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is a weak key used in cryptographic algorithm.",
  source.getNode(), "Random number"
