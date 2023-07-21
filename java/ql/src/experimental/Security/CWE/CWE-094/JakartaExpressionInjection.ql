/**
 * @name Jakarta Expression Language injection
 * @description Evaluation of a user-controlled expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/javaee-expression-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 */

import java
import JakartaExpressionInjectionLib
import JakartaExpressionInjectionFlow::PathGraph

from JakartaExpressionInjectionFlow::PathNode source, JakartaExpressionInjectionFlow::PathNode sink
where JakartaExpressionInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Jakarta Expression Language injection from $@.",
  source.getNode(), "this user input"
