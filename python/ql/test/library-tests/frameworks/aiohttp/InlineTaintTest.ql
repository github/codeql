import experimental.meta.InlineTaintTest
private import semmle.python.controlflow.internal.Cfg as Cfg

predicate isSafe(DataFlow::GuardNode g, Cfg::ControlFlowNode node, boolean branch) {
  g.(Cfg::CallNode).getFunction().(Cfg::NameNode).getId() = "is_safe" and
  node = g.(Cfg::CallNode).getArg(_) and
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
