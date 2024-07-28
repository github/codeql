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
import semmle.go.security.InsecureRandomness
import InsecureRandomness::Flow::PathGraph

from InsecureRandomness::Flow::PathNode source, InsecureRandomness::Flow::PathNode sink, string kind
where
  InsecureRandomness::Flow::flowPath(source, sink) and
  InsecureRandomness::isSinkWithKind(sink.getNode(), kind) and
  (
    kind != "A password-related function"
    or
    sink =
      min(InsecureRandomness::Flow::PathNode sink2, int line |
        InsecureRandomness::Flow::flowPath(_, sink2) and
        sink2.getNode().getRoot() = sink.getNode().getRoot() and
        line = sink2.getLocation().getStartLine()
      |
        sink2 order by line
      )
  )
select sink.getNode(), source, sink,
  kind + " depends on a $@ generated with a cryptographically weak RNG.", source.getNode(),
  "random number"
