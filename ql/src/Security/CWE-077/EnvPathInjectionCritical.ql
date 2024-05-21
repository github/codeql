/**
 * @name PATH Enviroment Variable built from user-controlled sources
 * @description Building the PATH environment variable from user-controlled sources may alter the execution of following system commands
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision very-high
 * @id actions/envpath-injection/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-077
 *       external/cwe/cwe-020
 */

import actions
import codeql.actions.security.EnvPathInjectionQuery
import EnvPathInjectionFlow::PathGraph

from EnvPathInjectionFlow::PathNode source, EnvPathInjectionFlow::PathNode sink
where
  EnvPathInjectionFlow::flowPath(source, sink) and
  (
    inPrivilegedCompositeAction(sink.getNode().asExpr())
    or
    inPrivilegedExternallyTriggerableJob(sink.getNode().asExpr())
  ) and
  (
    source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    sink.getNode() instanceof EnvPathInjectionFromFileReadSink
    or
    not source.getNode().(RemoteFlowSource).getSourceType() = "artifact"
  )
select sink.getNode(), source, sink,
  "Potential PATH environment variable injection in $@, which may be controlled by an external user.",
  sink, sink.getNode().toString()
