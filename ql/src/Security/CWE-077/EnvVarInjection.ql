/**
 * @name Enviroment Variable built from user-controlled sources
 * @description Building an environment variable from user-controlled sources may alter the execution of following system commands
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/envvar-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-077
 *       external/cwe/cwe-020
 */

import actions
import codeql.actions.security.EnvVarInjectionQuery
import EnvVarInjectionFlow::PathGraph

predicate artifactToFileRead(DataFlow::Node source, DataFlow::Node sink) {
  (
    not source.(RemoteFlowSource).getSourceType() = "artifact"
    or
    source.(RemoteFlowSource).getSourceType() = "artifact" and
    sink instanceof EnvVarInjectionFromFileReadSink
  )
}

from EnvVarInjectionFlow::PathNode source, EnvVarInjectionFlow::PathNode sink
where
  EnvVarInjectionFlow::flowPath(source, sink) and
  (
    // sink belongs to a composite action
    exists(sink.getNode().asExpr().getEnclosingCompositeAction())
    or
    // sink belongs to a non-privileged job
    exists(Job j |
      j = sink.getNode().asExpr().getEnclosingJob() and
      not j.isPrivileged()
    ) and
    // exclude paths to file read sinks from non-artifact sources
    artifactToFileRead(source.getNode(), sink.getNode())
  )
select sink.getNode(), source, sink,
  "Potential environment variable injection in $@, which may be controlled by an external user.",
  sink, sink.getNode().toString()
