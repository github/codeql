/**
 * @name Code injection with additional heuristic sources
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id js/code-injection-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.CodeInjectionQuery
import CodeInjectionFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
where CodeInjectionFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, sink.getNode().(Sink).getMessagePrefix() + " depends on a $@.",
  source.getNode(), "user-provided value"
