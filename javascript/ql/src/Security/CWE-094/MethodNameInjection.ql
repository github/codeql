/**
 * @name Method name injection
 * @description Invoking user-controlled methods on a arbitrary objects can lead to remote code execution.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/method-name-injection
 * @tags security
 *       external/cwe/cwe-094
 */
import javascript
import semmle.javascript.security.dataflow.MethodNameInjection::MethodNameInjection
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Invocation of method derived from $@ may lead to remote code execution.", source.getNode(), "user-controlled value"
