/**
 * @name Insecure randomness
 * @description Using insufficient randomness as the key of a cryptographic algorithm can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id python/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */

import python
import semmle.python.security.dataflow.InsecureRandomness::InsecureRandomness
import semmle.python.dataflow.new.DataFlow
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cryptographically insecure $@ in a security context.",
  source.getNode(), "random value"