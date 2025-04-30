/**
 * @name User-controlled bypass of security check with additional heuristic sources
 * @description Conditions that the user controls are not suited for making security-related decisions.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id js/user-controlled-bypass-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import javascript
import semmle.javascript.security.dataflow.ConditionalBypassQuery
import semmle.javascript.heuristics.AdditionalSources
import ConditionalBypassFlow::PathGraph

from
  ConditionalBypassFlow::PathNode source, ConditionalBypassFlow::PathNode sink,
  SensitiveAction action
where
  isTaintedGuardNodeForSensitiveAction(sink, source, action) and
  not isEarlyAbortGuardNode(sink, action) and
  source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "This condition guards a sensitive $@, but a $@ controls it.",
  action, "action", source.getNode(), "user-provided value"
