/**
 * @name Weak Randomness
 * @description Using a weak source of randomness may allow an attacker to predict the generated values.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.6
 * @precision high
 * @id java/weak-randomness
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
