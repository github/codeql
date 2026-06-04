import experimental.meta.InlineTaintTest
private import semmle.python.controlflow.internal.Cfg as Cfg

predicate isSafeCheck(DataFlow::GuardNode g, Cfg::ControlFlowNode node, boolean branch) {
  g.(Cfg::CallNode).getNode().getFunc().(Name).getId() in ["is_safe", "emulated_is_safe"] and
  node = g.(Cfg::CallNode).getAnArg() and
  branch = true
}

predicate isUnsafeCheck(DataFlow::GuardNode g, Cfg::ControlFlowNode node, boolean branch) {
  g.(Cfg::CallNode).getNode().getFunc().(Name).getId() in ["is_unsafe", "emulated_is_unsafe"] and
  node = g.(Cfg::CallNode).getAnArg() and
  branch = false
}

module CustomSanitizerOverridesConfig implements DataFlow::ConfigSig {
  predicate isSource = TestTaintTrackingConfig::isSource/1;

  predicate isSink = TestTaintTrackingConfig::isSink/1;

  predicate isBarrier(DataFlow::Node node) {
    exists(Call call |
      call.getFunc().(Name).getId() = "emulated_authentication_check" and
      call.getArg(0) = node.asExpr()
    )
    or
    node.asExpr().(Call).getFunc().(Name).getId() = "emulated_escaping"
    or
    node = DataFlow::BarrierGuard<isSafeCheck/3>::getABarrierNode()
    or
    node = DataFlow::BarrierGuard<isUnsafeCheck/3>::getABarrierNode()
  }
}

import MakeInlineTaintTest<CustomSanitizerOverridesConfig>

query predicate isSanitizer(DataFlow::Node node) {
  exists(node.getLocation().getFile().getRelativePath()) and
  CustomSanitizerOverridesConfig::isBarrier(node)
}
