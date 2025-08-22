/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id actions/code-injection/medium
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import actions
import codeql.actions.security.CodeInjectionQuery
import CodeInjectionFlow::PathGraph

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
where
  CodeInjectionFlow::flowPath(source, sink) and
  inNonPrivilegedContext(sink.getNode().asExpr()) and
  // exclude cases where the sink is a JS script and the expression uses toJson
  not exists(UsesStep script |
    script.getCallee() = "actions/github-script" and
    script.getArgumentExpr("script") = sink.getNode().asExpr() and
    exists(getAToJsonReferenceExpression(sink.getNode().asExpr().(Expression).getExpression(), _))
  )
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
