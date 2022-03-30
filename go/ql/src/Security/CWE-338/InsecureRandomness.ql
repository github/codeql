/**
 * @name Use of insufficient randomness as the key of a cryptographic algorithm
 * @description Using insufficient randomness as the key of a cryptographic algorithm can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id go/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */

import go
import semmle.go.security.InsecureRandomness::InsecureRandomness
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string kind
where
  cfg.hasFlowPath(source, sink) and
  cfg.isSink(sink.getNode(), kind) and
  (
    kind != "a password-related function"
    or
    sink =
      min(DataFlow::PathNode sink2, int line |
        cfg.hasFlowPath(_, sink2) and
        sink2.getNode().getRoot() = sink.getNode().getRoot() and
        sink2.hasLocationInfo(_, line, _, _, _)
      |
        sink2 order by line
      )
  )
select sink.getNode(), source, sink,
  "$@ generated with a cryptographically weak RNG is used in $@.", source.getNode(),
  "A random number", sink.getNode(), kind
