import python
import semmle.python.dataflow.new.DataFlow
import FlowTest

class MaximalFlowTest extends FlowTest {
  MaximalFlowTest() { this = "MaximalFlowTest" }

  override string flowTag() { result = "flow" }

  override predicate relevantFlow(DataFlow::Node source, DataFlow::Node sink) {
    source != sink and
    exists(MaximalFlowsConfig cfg | cfg.hasFlow(source, sink))
  }
}

/**
 * A configuration to find all "maximal" flows.
 * To be used on small programs.
 */
class MaximalFlowsConfig extends DataFlow::Configuration {
  MaximalFlowsConfig() { this = "MaximalFlowsConfig" }

  override predicate isSource(DataFlow::Node node) {
    not node.asCfgNode() instanceof CallNode and
    not node.asCfgNode().getNode() instanceof Return and
    not node instanceof DataFlow::ParameterNode and
    not exists(DataFlow::Node pred | DataFlow::localFlowStep(pred, node))
  }

  override predicate isSink(DataFlow::Node node) {
    not any(CallNode c).getArg(_) = node.asCfgNode() and
    not exists(DataFlow::Node succ | DataFlow::localFlowStep(node, succ))
  }
}
