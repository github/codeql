/**
 * @name User-controlled bypass of security check
 * @description Conditions that the user controls are not suited for making security-related decisions.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id js/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import javascript
import semmle.javascript.security.dataflow.ConditionalBypassQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, SensitiveAction action
where
  isTaintedGuardForSensitiveAction(sink, source, action) and
  not isEarlyAbortGuard(sink, action)
select sink.getNode(), source, sink, "This condition guards a sensitive $@, but a $@ controls it.",
  action, "action", source.getNode(), "user-provided value"
