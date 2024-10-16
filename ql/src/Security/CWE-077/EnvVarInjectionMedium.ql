/**
 * @name Enviroment Variable built from user-controlled sources
 * @description Building an environment variable from user-controlled sources may alter the execution of following system commands
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/envvar-injection/medium
 * @tags actions
 *       security
 *       external/cwe/cwe-077
 *       external/cwe/cwe-020
 */

import actions
import codeql.actions.security.EnvVarInjectionQuery
import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import EnvVarInjectionFlow::PathGraph

from EnvVarInjectionFlow::PathNode source, EnvVarInjectionFlow::PathNode sink
where
  EnvVarInjectionFlow::flowPath(source, sink) and
  inNonPrivilegedContext(sink.getNode().asExpr()) and
  // exclude paths to file read sinks from non-artifact sources
  (
    not source.getNode().(RemoteFlowSource).getSourceType() = "artifact"
    or
    source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    (
      sink.getNode() instanceof EnvVarInjectionFromFileReadSink or
      madSink(sink.getNode(), "envvar-injection")
    )
  )
select sink.getNode(), source, sink,
  "Potential environment variable injection in $@, which may be controlled by an external user.",
  sink, sink.getNode().toString()
