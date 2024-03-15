/**
 * @name Command built from user-controlled sources on a privileged context
 * @description Building a system command from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id actions/privileged-command-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-078
 */

import actions
import codeql.actions.security.CommandInjectionQuery
import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink, Workflow w
where
  CommandInjectionFlow::flowPath(source, sink) and
  w = source.getNode().asExpr().getEnclosingWorkflow() and
  (
    w instanceof ReusableWorkflow or
    w.hasTriggerEvent(source.getNode().(RemoteFlowSource).getATriggerEvent())
  )
select sink.getNode(), source, sink,
  "Potential privileged command injection in $@, which may be controlled by an external user.",
  sink, sink.getNode().asExpr().(Expression).getRawExpression()
