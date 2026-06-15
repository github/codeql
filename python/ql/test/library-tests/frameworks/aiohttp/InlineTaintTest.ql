import experimental.meta.InlineTaintTest

predicate isSafe(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  g.(CallNode).getFunction().(NameNode).getId() = "is_safe" and
  node = g.(CallNode).getArg(_) and
  branch = true
}

module CustomSanitizerOverridesConfig implements DataFlow::ConfigSig {
  predicate isSource = TestTaintTrackingConfig::isSource/1;

  predicate isSink = TestTaintTrackingConfig::isSink/1;

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<isSafe/3>::getABarrierNode()
  }
}

import MakeInlineTaintTest<CustomSanitizerOverridesConfig>
