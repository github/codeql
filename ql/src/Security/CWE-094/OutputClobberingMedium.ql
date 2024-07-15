/**
 * @name Output Clobbering
 * @description A Step output can be clobbered which may allow an attacker to manipulate the expected and trusted values of a variable.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id actions/output-clobbering/medium
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import actions
import codeql.actions.security.OutputClobberingQuery
import OutputClobberingFlow::PathGraph

from OutputClobberingFlow::PathNode source, OutputClobberingFlow::PathNode sink
where
  OutputClobberingFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr()) and
  // exclude cases where the sink is a JS script and the expression uses toJson
  not exists(UsesStep script |
    script.getCallee() = "actions/github-script" and
    script.getArgumentExpr("script") = sink.getNode().asExpr() and
    exists(getAToJsonReferenceExpression(sink.getNode().asExpr().(Expression).getExpression(), _))
  )
select sink.getNode(), source, sink, "Potential output clobbering leading to code injection in $@.",
  sink, sink.getNode().asExpr().(Expression).getRawExpression()
