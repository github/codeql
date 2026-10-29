/**
 * @name Expression language injection (MVEL)
 * @description Evaluation of a user-controlled MVEL expression
 *              may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/mvel-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.MvelInjectionQuery
import MvelInjectionFlow::PathGraph

from MvelInjectionFlow::PathNode source, MvelInjectionFlow::PathNode sink
where MvelInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "MVEL expression depends on a $@.", source.getNode(),
  "user-provided value"
