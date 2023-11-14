/**
 * @name Insecure randomness
 * @description Using a cryptographically weak pseudo-random number generator to generate a
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
import semmle.code.java.security.WeakRandomnessQuery
import WeakRandomnessFlow::PathGraph

from WeakRandomnessFlow::PathNode source, WeakRandomnessFlow::PathNode sink
where WeakRandomnessFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potential weak randomness due to a $@.", source.getNode(),
  "weak randomness source."
