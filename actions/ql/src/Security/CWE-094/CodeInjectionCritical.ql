/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision very-high
 * @id actions/code-injection/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import actions
import codeql.actions.security.CodeInjectionQuery
import CodeInjectionFlow::PathGraph
import codeql.actions.security.ControlChecks

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink, Event event
where
  CodeInjectionFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr(), event) and
  source.getNode().(RemoteFlowSource).getEventName() = event.getName() and
  not exists(ControlCheck check | check.protects(sink.getNode().asExpr(), event, "code-injection")) and
  // exclude cases where the sink is a JS script and the expression uses toJson
  not exists(UsesStep script |
    script.getCallee() = "actions/github-script" and
    script.getArgumentExpr("script") = sink.getNode().asExpr() and
    exists(getAToJsonReferenceExpression(sink.getNode().asExpr().(Expression).getExpression(), _))
  )
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by an external user ($@).", sink,
  sink.getNode().asExpr().(Expression).getRawExpression(), event, event.getName()
