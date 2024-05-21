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
 *       external/cwe/cwe-078
 */

import actions
import codeql.actions.security.CommandInjectionQuery
import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink
where
  CommandInjectionFlow::flowPath(source, sink) and
  (
    inPrivilegedCompositeAction(sink.getNode().asExpr())
    or
    inPrivilegedExternallyTriggerableJob(sink.getNode().asExpr())
  )
select sink.getNode(), source, sink,
  "Potential command injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
