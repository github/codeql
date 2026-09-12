/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
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
import CodeInjectionFromStepOutputFlow::PathGraph

from
  CodeInjectionFromStepOutputFlow::PathNode source, CodeInjectionFromStepOutputFlow::PathNode sink
where lowSeverityCodeInjection(source, sink)
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by an external user because it comes from a step output.",
  sink, sink.getNode().asExpr().(Expression).getRawExpression()
