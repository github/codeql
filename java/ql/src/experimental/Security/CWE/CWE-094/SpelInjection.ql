/**
 * @name Expression language injection (Spring)
 * @description Evaluation of a user-controlled Spring Expression Language (SpEL) expression
 *              may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/spel-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import SpelInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, ExpressionInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "SpEL injection from $@.", source.getNode(), "this user input"
