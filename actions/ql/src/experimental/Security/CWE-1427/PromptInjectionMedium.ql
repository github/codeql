/**
 * @name Prompt injection from user-controlled Actions input (medium severity)
 * @description User-controlled data flowing into AI prompts on non-privileged
 *              but externally triggerable events (e.g. pull_request) may allow
 *              attackers to manipulate AI behavior through prompt injection.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id actions/prompt-injection/medium
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-1427
 */

import actions
import codeql.actions.security.PromptInjectionQuery
import PromptInjectionFlow::PathGraph

from PromptInjectionFlow::PathNode source, PromptInjectionFlow::PathNode sink, Event event
where mediumSeverityPromptInjection(source, sink, event)
select sink.getNode(), source, sink,
  "Potential prompt injection in $@, which may be controlled by an external user ($@).", sink,
  sink.getNode().asExpr().(Expression).getRawExpression(), event, event.getName()
