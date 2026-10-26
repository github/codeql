/**
 * @name Insecure randomness
 * @description Using a cryptographically weak pseudo-random number generator to generate a
 *              security-sensitive value may allow an attacker to predict what value will
 *              be generated.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id js/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */

import javascript
import semmle.javascript.security.dataflow.InsecureRandomnessQuery
import InsecureRandomnessFlow::PathGraph

from InsecureRandomnessFlow::PathNode source, InsecureRandomnessFlow::PathNode sink
where InsecureRandomnessFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This uses a cryptographically insecure random number generated at $@ in a security context.",
  source.getNode(), source.getNode().toString()
