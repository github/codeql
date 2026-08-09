/**
 * @name User prompt injection
 * @description Untrusted input flowing into a user-role prompt of an AI model
 *              may allow an attacker to manipulate the model's behavior.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision low
 * @id js/user-prompt-injection
 * @tags security
 *       external/cwe/cwe-1427
 */

import javascript
import semmle.javascript.security.dataflow.UserPromptInjectionQuery
import UserPromptInjectionFlow::PathGraph

from UserPromptInjectionFlow::PathNode source, UserPromptInjectionFlow::PathNode sink
where UserPromptInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This prompt construction depends on a $@.", source.getNode(),
  "user-provided value"
