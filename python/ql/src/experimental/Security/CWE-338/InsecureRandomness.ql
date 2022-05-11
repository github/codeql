/**
 * @name Insecure randomness
 * @description Using a cryptographically weak pseudo-random number generator to generate a
 *              security-sensitive value may allow an attacker to predict what value will
 *              be generated.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id py/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */

import python
import experimental.semmle.python.security.InsecureRandomness::InsecureRandomness
import semmle.python.dataflow.new.DataFlow
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cryptographically insecure $@ in a security context.",
  source.getNode(), "random value"
