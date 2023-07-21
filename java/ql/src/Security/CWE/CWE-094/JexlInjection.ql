/**
 * @name Expression language injection (JEXL)
 * @description Evaluation of a user-controlled JEXL expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/jexl-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.JexlInjectionQuery
import JexlInjectionFlow::PathGraph

from JexlInjectionFlow::PathNode source, JexlInjectionFlow::PathNode sink
where JexlInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "JEXL expression depends on a $@.", source.getNode(),
  "user-provided value"
