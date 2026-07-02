/**
 * @name System prompt injection
 * @description Untrusted input flowing into a system prompt, developer prompt, or tool description
 *              of an AI model may allow an attacker to manipulate the model's behavior.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id py/system-prompt-injection
 * @tags security
 *       external/cwe/cwe-1427
 */

import python
import semmle.python.security.dataflow.SystemPromptInjectionQuery
import SystemPromptInjectionFlow::PathGraph

from SystemPromptInjectionFlow::PathNode source, SystemPromptInjectionFlow::PathNode sink
where SystemPromptInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This system prompt depends on a $@.", source.getNode(),
  "user-provided value"
