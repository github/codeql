import go
import semmle.go.dataflow.internal.DataFlowNodes as Nodes
import semmle.go.dataflow.SsaImpl

private predicate sourceNode(DataFlow::Node node) {
  node.(DataFlow::CallNode).getTarget().getName() = "source" and
  node.getEnclosingCallable().getName() = ["readMerge", "writeMerge", "loop"]
}

private predicate sinkNode(DataFlow::Node node) {
  node = any(DataFlow::CallNode call | call.getTarget().getName() = "sink").getArgument(0) and
  node.getEnclosingCallable().getName() = ["readMerge", "writeMerge", "loop"]
}

module NeverSkipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { sourceNode(node) }

  predicate isSink(DataFlow::Node node) { sinkNode(node) }

  predicate neverSkip(DataFlow::Node node) { any() }
}

module NeverSkipFlow = DataFlow::Global<NeverSkipConfig>;

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

private predicate pathNode(string mode, DataFlow::Node node) {
  exists(NeverSkipFlow::PathNode p |
    (
      NeverSkipFlow::PathGraph::edges(p, _, _, _) or
      NeverSkipFlow::PathGraph::edges(_, p, _, _)
    ) and
    mode = "neverSkip" and
    node = p.getNode()
  )
  or
  exists(StatefulFlow::PathNode p |
    (
      StatefulFlow::PathGraph::edges(p, _, _, _) or
      StatefulFlow::PathGraph::edges(_, p, _, _)
    ) and
    mode = "stateful" and
    node = p.getNode()
  )
}

private predicate flow(string mode, DataFlow::Node source, DataFlow::Node sink) {
  mode = "neverSkip" and NeverSkipFlow::flow(source, sink)
  or
  mode = "stateful" and StatefulFlow::flow(source, sink)
}

from string mode
where mode = ["neverSkip", "stateful"]
select mode, count(DataFlow::Node source, DataFlow::Node sink | flow(mode, source, sink)) as flows,
  count(DataFlow::Node n | pathNode(mode, n) and n instanceof Nodes::Private::SsaSynthReadNode) as syntheticReads,
  count(DataFlow::SsaNode n | pathNode(mode, n) and n.getDefinition() instanceof PhiNode) as phis
