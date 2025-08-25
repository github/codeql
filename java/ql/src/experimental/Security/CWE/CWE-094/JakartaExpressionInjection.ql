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
deprecated import JakartaExpressionInjectionLib
deprecated import JakartaExpressionInjectionFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, JakartaExpressionInjectionFlow::PathNode source,
  JakartaExpressionInjectionFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  JakartaExpressionInjectionFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Jakarta Expression Language injection from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}
