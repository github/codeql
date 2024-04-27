/**
 * @name PATH Enviroment Variable built from user-controlled sources
 * @description Building the PATH environment variable from user-controlled sources may alter the execution of following system commands
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/envpath-injection
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
    exists(sink.getNode().asExpr().getEnclosingCompositeAction())
    or
    exists(Job j |
      j = sink.getNode().asExpr().getEnclosingJob() and
      not j.isPrivileged()
    ) and
    (
      not source.getNode().(RemoteFlowSource).getSourceType() = "artifact"
      or
      source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
      sink.getNode() instanceof EnvPathInjectionFromFileReadSink
    )
  )
select sink.getNode(), source, sink,
  "Potential PATH environment variable injection in $@, which may be controlled by an external user.",
  sink, sink.getNode().toString()
