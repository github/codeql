import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate
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
    exists(node.getLocation().getFile().getRelativePath()) and
    not node.asCfgNode() instanceof CallNode and
    not node.asCfgNode().getNode() instanceof Return and
    not node instanceof DataFlow::ParameterNode and
    not node instanceof DataFlow::PostUpdateNode and
    // not node.asExpr() instanceof FunctionExpr and
    // not node.asExpr() instanceof ClassExpr and
    not exists(DataFlow::Node pred | DataFlow::localFlowStep(pred, node))
  }

  override predicate isSink(DataFlow::Node node) {
    exists(node.getLocation().getFile().getRelativePath()) and
    not any(CallNode c).getArg(_) = node.asCfgNode() and
    not node instanceof DataFlow::ArgumentNode and
    not node.asCfgNode().(NameNode).getId().matches("SINK%") and
    not exists(DataFlow::Node succ | DataFlow::localFlowStep(node, succ))
  }
}
