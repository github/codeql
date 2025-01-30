import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineFlowTest

predicate isBad(DataFlow::Node g, Expr e, boolean branch) {
  g.(DataFlow::CallNode).getTarget().getName() = "isBad" and
  e = g.(DataFlow::CallNode).getAnArgument().asExpr() and
  branch = false
}

module FlowWithBarrierConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink = DefaultFlowConfig::isSink/1;

  predicate fieldFlowBranchLimit = DefaultFlowConfig::fieldFlowBranchLimit/0;

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<isBad/3>::getABarrierNode()
  }
}

import ValueFlowTest<FlowWithBarrierConfig>
