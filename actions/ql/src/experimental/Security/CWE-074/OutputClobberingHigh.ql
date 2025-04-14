/**
 * @name Output Clobbering
 * @description A Step output can be clobbered which may allow an attacker to manipulate the expected and trusted values of a variable.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.3
 * @precision high
 * @id actions/output-clobbering/high
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-074
 */

import actions
import codeql.actions.security.OutputClobberingQuery
import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import OutputClobberingFlow::PathGraph
import codeql.actions.security.ControlChecks

from OutputClobberingFlow::PathNode source, OutputClobberingFlow::PathNode sink, Event event
where
  OutputClobberingFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr(), event) and
  // exclude paths to file read sinks from non-artifact sources
  (
    not source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    not exists(ControlCheck check |
      check.protects(sink.getNode().asExpr(), event, "code-injection")
    )
    or
    source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    not exists(ControlCheck check |
      check.protects(sink.getNode().asExpr(), event, ["untrusted-checkout", "artifact-poisoning"])
    ) and
    (
      sink.getNode() instanceof OutputClobberingFromFileReadSink or
      sink.getNode() instanceof WorkflowCommandClobberingFromFileReadSink or
      madSink(sink.getNode(), "output-clobbering")
    )
  )
select sink.getNode(), source, sink, "Potential clobbering of a step output in $@.", sink,
  sink.getNode().toString()
