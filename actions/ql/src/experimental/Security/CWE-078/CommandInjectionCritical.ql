/**
 * @name Command built from user-controlled sources
 * @description Building a system command from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision very-high
 * @id actions/command-injection/critical
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-078
 */

import actions
import codeql.actions.security.CommandInjectionQuery
import CommandInjectionFlow::PathGraph
import codeql.actions.security.ControlChecks

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink, Event event
where
  CommandInjectionFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr(), event) and
  not exists(ControlCheck check |
    check.protects(sink.getNode().asExpr(), event, ["command-injection", "code-injection"])
  )
select sink.getNode(), source, sink,
  "Potential command injection in $@, which may be controlled by an external user ($@).", sink,
  sink.getNode().asExpr().(Expression).getRawExpression(), event, event.getName()
