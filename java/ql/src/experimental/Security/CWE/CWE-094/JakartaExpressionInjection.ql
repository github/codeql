/**
 * @name Java EE Expression Language injection
 * @description Evaluation of a user-controlled Jave EE expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/javaee-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import JavaEEExpressionInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, JavaEEExpressionInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Java EE Expression Language injection from $@.",
  source.getNode(), "this user input"
