/**
 * @name Insecure randomness
 * @description Using a cryptographically Insecure pseudo-random number generator to generate a
 *              security-sensitive value may allow an attacker to predict what value will
 *              be generated.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id java/insecure-randomness
 * @tags security
 *      external/cwe/cwe-330
 *      external/cwe/cwe-338
 */

import java
import semmle.code.java.security.InsecureRandomnessQuery
import InsecureRandomnessFlow::PathGraph

from InsecureRandomnessFlow::PathNode source, InsecureRandomnessFlow::PathNode sink
where InsecureRandomnessFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potential Insecure randomness due to a $@.", source.getNode(),
  "Insecure randomness source."
