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
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import actions
import codeql.actions.security.OutputClobberingQuery
import codeql.actions.dataflow.ExternalFlow
import OutputClobberingFlow::PathGraph

from OutputClobberingFlow::PathNode source, OutputClobberingFlow::PathNode sink
where
  OutputClobberingFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr()) and
  // exclude paths to file read sinks from non-artifact sources
  (
    not source.getNode().(RemoteFlowSource).getSourceType() = "artifact"
    or
    source.getNode().(RemoteFlowSource).getSourceType() = "artifact" and
    (
      sink.getNode() instanceof OutputClobberingFromFileReadSink or
      madSink(sink.getNode(), "output-clobbering")
    )
  )
select sink.getNode(), source, sink, "Potential clobbering of a step output in $@.", sink,
  sink.getNode().toString()
