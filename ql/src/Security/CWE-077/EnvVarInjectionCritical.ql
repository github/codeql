/**
 * @name Enviroment Variable built from user-controlled sources
 * @description Building an environment variable from user-controlled sources may alter the execution of following system commands
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision very-high
 * @id actions/envvar-injection/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-077
 *       external/cwe/cwe-020
 */

import actions
import codeql.actions.security.EnvVarInjectionQuery
import codeql.actions.dataflow.ExternalFlow
import EnvVarInjectionFlow::PathGraph
import codeql.actions.security.ControlChecks

from EnvVarInjectionFlow::PathNode source, EnvVarInjectionFlow::PathNode sink
where
  EnvVarInjectionFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr()) and
  not exists(ControlCheck check |
    check
        .protects(sink.getNode().asExpr(),
          source.getNode().asExpr().getEnclosingJob().getATriggerEvent(), "envvar-injection")
  ) and
  // exclude paths to file read sinks from non-artifact sources
  (
    not source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    not exists(ControlCheck check |
      check
          .protects(sink.getNode().asExpr(),
            source.getNode().asExpr().getEnclosingJob().getATriggerEvent(), "code-injection")
    )
    or
    source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    not exists(ControlCheck check |
      check
          .protects(sink.getNode().asExpr(),
            source.getNode().asExpr().getEnclosingJob().getATriggerEvent(),
            ["untrusted-checkout", "artifact-poisoning"])
    ) and
    (
      sink.getNode() instanceof EnvVarInjectionFromFileReadSink or
      madSink(sink.getNode(), "envvar-injection")
    )
  )
select sink.getNode(), source, sink,
  "Potential environment variable injection in $@, which may be controlled by an external user.",
  sink, sink.getNode().toString()
