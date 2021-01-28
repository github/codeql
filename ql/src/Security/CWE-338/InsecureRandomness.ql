/**
 * @name Use of insufficient randomness as the key of a cryptographic algorithm
 * @description Using insufficient randomness as the key of a cryptographic algorithm can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id go/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */

import go
import semmle.go.security.InsecureRandomness::InsecureRandomness
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string kind
where cfg.hasFlowPath(source, sink) and cfg.isSink(sink.getNode(), kind)
select sink.getNode(), source, sink,
  "$@ generated with a cryptographically weak RNG is used in $@.", source.getNode(),
  "A random number", sink.getNode(), kind
