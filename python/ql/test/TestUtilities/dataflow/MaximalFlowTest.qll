import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate
import FlowTest

module MaximalFlowTest implements FlowTestSig {
  string flowTag() { result = "flow" }

  predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    source != sink and
    MaximalFlows::flow(source, sink)
  }
}

import MakeTest<MakeTestSig<MaximalFlowTest>>

/**
 * A configuration to find all "maximal" flows.
 * To be used on small programs.
 */
module MaximalFlowsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    exists(node.getLocation().getFile().getRelativePath()) and
    not node.asCfgNode() instanceof CallNode and
    not node.asCfgNode().getNode() instanceof Return and
    not node instanceof DataFlow::ParameterNode and
    not node instanceof DataFlow::PostUpdateNode and
    // not node.asExpr() instanceof FunctionExpr and
    // not node.asExpr() instanceof ClassExpr and
    not DataFlow::localFlowStep(_, node)
  }

  predicate isSink(DataFlow::Node node) {
    exists(node.getLocation().getFile().getRelativePath()) and
    not any(CallNode c).getArg(_) = node.asCfgNode() and
    not node instanceof DataFlow::ArgumentNode and
    not node.asCfgNode().(NameNode).getId().matches("SINK%") and
    not DataFlow::localFlowStep(node, _)
  }
}

module MaximalFlows = DataFlow::Global<MaximalFlowsConfig>;
