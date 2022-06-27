import experimental.meta.InlineTaintTest

predicate isSafeCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  g.(CallNode).getNode().getFunc().(Name).getId() in ["is_safe", "emulated_is_safe"] and
  node = g.(CallNode).getAnArg() and
  branch = true
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
  }
}

query predicate isSanitizer(TestTaintTrackingConfiguration conf, DataFlow::Node node) {
  exists(node.getLocation().getFile().getRelativePath()) and
  conf.isSanitizer(node)
}
