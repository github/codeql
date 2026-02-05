/**
 * @name Prompt injection
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id py/prompt-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-1427
 */

import python
import experimental.semmle.python.security.dataflow.PromptInjectionQuery
import PromptInjectionFlow::PathGraph

from PromptInjectionFlow::PathNode source, PromptInjectionFlow::PathNode sink
where PromptInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This prompt construction depends on a $@.", source.getNode(),
  "user-provided value"
