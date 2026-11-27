/**
 * @kind path-problem
 */

import go

private predicate inTestCallable(DataFlow::Node node) {
  node.getRoot().getEnclosingFunction*().(FuncDecl).getFunction().getName() =
    ["readMerge", "writeMerge", "loop", "capturedWrite", "capturedRead", "uncertainUpdate"]
}

private predicate sourceNode(DataFlow::Node node) {
  node.(DataFlow::CallNode).getTarget().getName() = "source" and
  inTestCallable(node)
}

private predicate sinkNode(DataFlow::Node node) {
  node = any(DataFlow::CallNode call | call.getTarget().getName() = "sink").getArgument(0) and
  inTestCallable(node)
}

module StatefulConfig implements DataFlow::StateConfigSig {
  class FlowState extends string {
    FlowState() { this = ["initial", "marked"] }
  }

  predicate isSource(DataFlow::Node node, FlowState state) {
    sourceNode(node) and state = "initial"
  }

  predicate isSink(DataFlow::Node node, FlowState state) { sinkNode(node) and state = "marked" }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    node1 = node2 and
    node1.getType().getUnderlyingType() instanceof StringType and
    state1 = "initial" and
    state2 = "marked"
  }
}

module StatefulFlow = DataFlow::GlobalWithState<StatefulConfig>;

import StatefulFlow::PathGraph

from StatefulFlow::PathNode source, StatefulFlow::PathNode sink
where StatefulFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "stateful"
