/**
 * @name Jakarta Expression Language injection
 * @description Evaluation of a user-controlled expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/javaee-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import JakartaExpressionInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, JakartaExpressionInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Jakarta Expression Language injection from $@.",
  source.getNode(), "this user input"
