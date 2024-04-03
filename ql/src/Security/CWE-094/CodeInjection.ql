/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/code-injection
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
  (
    exists(source.getNode().asExpr().getEnclosingCompositeAction())
    or
    exists(Workflow w |
      w = source.getNode().asExpr().getEnclosingWorkflow() and
      not w.isPrivileged()
    )
  )
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
