/**
 * @name Argument injection
 * @description Passing unsanitized user input to a command that will run it as a subprocess.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision medium
 * @id actions/argument-injection/medium
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-088
 */

import actions
import codeql.actions.security.ArgumentInjectionQuery
import ArgumentInjectionFlow::PathGraph

from ArgumentInjectionFlow::PathNode source, ArgumentInjectionFlow::PathNode sink
where
  ArgumentInjectionFlow::flowPath(source, sink) and
  inNonPrivilegedContext(sink.getNode().asExpr())
select sink.getNode(), source, sink,
  "Potential argument injection in $@ command, which may be controlled by an external user.", sink,
  sink.getNode().(ArgumentInjectionSink).getCommand()
