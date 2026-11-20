/**
 * @name Prompt injection from user-controlled Actions input
 * @description User-controlled data flowing into AI prompts in a privileged context
 *              may allow attackers to manipulate AI behavior through prompt injection.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id actions/prompt-injection/critical
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-1427
 */

import actions
import codeql.actions.security.PromptInjectionQuery
import PromptInjectionFlow::PathGraph

from PromptInjectionFlow::PathNode source, PromptInjectionFlow::PathNode sink, Event event
where criticalSeverityPromptInjection(source, sink, event)
select sink.getNode(), source, sink,
  "Potential prompt injection in $@, which may be controlled by an external user ($@).", sink,
  sink.getNode().asExpr().(Expression).getRawExpression(), event, event.getName()
