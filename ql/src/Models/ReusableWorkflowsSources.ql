/**
 * @name Reusable Workflow Sources
 * @description Reusable Workflow that pass user-controlled data to their output variables.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id actions/reusable-workflow-sources
 * @tags actions
 *       model-generator
 *       external/cwe/cwe-020
 */

import actions
import codeql.actions.DataFlow
import codeql.actions.TaintTracking
import codeql.actions.dataflow.FlowSources
import codeql.actions.dataflow.ExternalFlow

private module MyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not source instanceof DataFlow::ParameterNode and
    exists(ReusableWorkflow w | w.getAChildNode*() = source.asExpr())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ReusableWorkflow w | w.getAnOutputExpr() = sink.asExpr())
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet set) {
    allowImplicitRead(node, set)
    or
    isSink(node) and
    set instanceof DataFlow::FieldContent
  }
}

module MyFlow = TaintTracking::Global<MyConfig>;

import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where
  MyFlow::flowPath(source, sink) and
  source.getNode().getLocation().getFile() = sink.getNode().getLocation().getFile()
select sink.getNode(), source, sink, "Source"
