/**
 * @name Expression language injection (Spring)
 * @description Evaluation of a user-controlled Spring Expression Language (SpEL) expression
 *              may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/spel-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.SpelInjectionQuery
import semmle.code.java.dataflow.DataFlow
import SpelInjectionFlow::PathGraph

from SpelInjectionFlow::PathNode source, SpelInjectionFlow::PathNode sink
where SpelInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "SpEL expression depends on a $@.", source.getNode(),
  "user-provided value"
