/**
 * @name Code injection on a privileged context
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id actions/privileged-code-injection
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
  exists(Job j |
    j = sink.getNode().asExpr().getEnclosingJob() and
    j.isPrivileged()
  )
select sink.getNode(), source, sink,
  "Potential privileged code injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
