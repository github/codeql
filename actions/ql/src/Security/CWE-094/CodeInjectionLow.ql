/**
 * @name Code injection
 * @description Using unsanitized workflow_call inputs as code allows a calling workflow to
 *              pass untrusted user input, leading to code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 3.0
 * @precision low
 * @id actions/code-injection/low
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
where lowSeverityCodeInjection(source, sink)
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by a calling workflow.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
