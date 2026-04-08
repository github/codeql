/**
 * @name Improper validation of AI-generated output
 * @description AI-generated output flowing unsanitized to code execution or
 *              subsequent AI prompts may allow chained prompt injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id actions/improper-validation-of-ai-output/critical
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-1426
 */

import actions
import codeql.actions.security.ImproperValidationOfAiOutputQuery
import ImproperAiOutputFlow::PathGraph

from ImproperAiOutputFlow::PathNode source, ImproperAiOutputFlow::PathNode sink, Event event
where criticalAiOutputInjection(source, sink, event)
select sink.getNode(), source, sink,
  "AI-generated output flows unsanitized to $@, which may allow chained injection ($@).", sink,
  sink.getNode().asExpr().(Expression).getRawExpression(), event, event.getName()
