import experimental.meta.InlineTaintTest

predicate isSafeCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  g.(CallNode).getNode().getFunc().(Name).getId() in ["is_safe", "emulated_is_safe"] and
  node = g.(CallNode).getAnArg() and
  branch = true
}

predicate isUnsafeCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  g.(CallNode).getNode().getFunc().(Name).getId() in ["is_unsafe", "emulated_is_unsafe"] and
  node = g.(CallNode).getAnArg() and
  branch = false
}

class CustomSanitizerOverrides extends TestTaintTrackingConfiguration {
  override predicate isSanitizer(DataFlow::Node node) {
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

query predicate isSanitizer(TestTaintTrackingConfiguration conf, DataFlow::Node node) {
  exists(node.getLocation().getFile().getRelativePath()) and
  conf.isSanitizer(node)
}
