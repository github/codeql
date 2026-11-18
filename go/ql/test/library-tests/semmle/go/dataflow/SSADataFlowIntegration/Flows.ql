import go
import utils.test.InlineFlowTest
private import semmle.go.dataflow.internal.DataFlowNodes::Private as Nodes
private import semmle.go.dataflow.internal.DataFlowPrivate as PrivateFlow

predicate isBad(DataFlow::Node g, Expr e, boolean branch) {
  g.(DataFlow::CallNode).getTarget().getName() = "isBad" and
  e = g.(DataFlow::CallNode).getArgument(0).asExpr() and
  branch = false
}

module Config implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate fieldFlowBranchLimit = DefaultFlowConfig::fieldFlowBranchLimit/0;

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<isBad/3>::getABarrierNode()
  }
}

import ValueFlowTest<Config>

query predicate unscopedSsaNode(DataFlow::Node node) {
  (node instanceof DataFlow::SsaNode or node instanceof Nodes::SsaSynthReadNode) and
  not exists(PrivateFlow::NodeRegion region |
    region.contains(node) and
    region.(BasicBlock).getScope() = node.getRoot()
  )
}
