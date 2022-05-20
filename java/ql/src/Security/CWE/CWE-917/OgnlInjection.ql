/**
 * @name OGNL Expression Language statement with user-controlled input
 * @description Evaluation of OGNL Expression Language statement with user-controlled input can
 *                lead to execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/ognl-injection
 * @tags security
 *       external/cwe/cwe-917
 */

import java
import semmle.code.java.security.OgnlInjectionQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, OgnlInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "OGNL expression might include data from $@.",
  source.getNode(), "this user input"
