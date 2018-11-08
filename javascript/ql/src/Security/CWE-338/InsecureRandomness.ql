/**
 * @name Insecure randomness
 * @description Using a cryptographically weak pseudo-random number generator to generate a
 *              security-sensitive value may allow an attacker to predict what value will
 *              be generated.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/insecure-randomness
 * @tags security
 *       external/cwe/cwe-338
 */
import javascript
import semmle.javascript.security.dataflow.InsecureRandomness::InsecureRandomness
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasPathFlow(source, sink)
select sink.getNode(), "Cryptographically insecure $@ in a security context.", source, "random value"
