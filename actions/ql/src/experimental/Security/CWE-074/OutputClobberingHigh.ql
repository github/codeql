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

private predicate isEnvironmentFileSink(OutputClobberingFlow::PathNode sink) {
  sink.getNode() instanceof OutputClobberingFromFileReadSink or
  sink.getNode() instanceof OutputClobberingFromEnvVarSink
}

private predicate isWorkflowCommandSink(OutputClobberingFlow::PathNode sink) {
  sink.getNode() instanceof WorkflowCommandClobberingFromFileReadSink or
  sink.getNode() instanceof WorkflowCommandClobberingFromEnvVarSink
}

private string getMessage(OutputClobberingFlow::PathNode sink) {
  isEnvironmentFileSink(sink) and
  result =
    "Attacker-controlled data may inject or overwrite step outputs written through " +
      "`$GITHUB_OUTPUT` in $@."
  or
  not isEnvironmentFileSink(sink) and
  isWorkflowCommandSink(sink) and
  result =
    "Attacker-controlled data printed to standard output may forge a `set-output` " +
      "workflow command and overwrite step outputs in $@."
  or
  not isEnvironmentFileSink(sink) and
  not isWorkflowCommandSink(sink) and
  result = "Attacker-controlled data may inject or overwrite step outputs in $@."
}

private string getSinkLabel(OutputClobberingFlow::PathNode sink) {
  (isEnvironmentFileSink(sink) or isWorkflowCommandSink(sink)) and
  result = "this step"
  or
  not isEnvironmentFileSink(sink) and
  not isWorkflowCommandSink(sink) and
  result = "this action"
}

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
select sink.getNode(), source, sink, getMessage(sink), sink, getSinkLabel(sink)
