import experimental.dataflow.tainttracking.TestTaintLib

class IsSafeCheck extends DataFlow::BarrierGuard {
  IsSafeCheck() { this.(CallNode).getNode().getFunc().(Name).getId() = "emulated_is_safe" }

  override predicate checks(ControlFlowNode node, boolean branch) {
    node = this.(CallNode).getAnArg() and
    branch = true
  }
}

class CustomSanitizerOverrides extends TestTaintTrackingConfiguration {
  override predicate isSanitizer(DataFlow::Node node) {
    exists(Call call |
      call.getFunc().(Name).getId() = "emulated_authentication_check" and
      call.getArg(0) = node.asExpr()
    )
    or
    node.asExpr().(Call).getFunc().(Name).getId() = "emulated_escaping"
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { guard instanceof IsSafeCheck }
}

query predicate isSanitizer(TestTaintTrackingConfiguration conf, DataFlow::Node node) {
  exists(node.getLocation().getFile().getRelativePath()) and
  conf.isSanitizer(node)
}

query predicate isSanitizerGuard(TestTaintTrackingConfiguration conf, DataFlow::BarrierGuard guard) {
  exists(guard.getLocation().getFile().getRelativePath()) and
  conf.isSanitizerGuard(guard)
}

query predicate sanitizerGuardControls(
  TestTaintTrackingConfiguration conf, DataFlow::BarrierGuard guard, ControlFlowNode node,
  boolean branch
) {
  exists(guard.getLocation().getFile().getRelativePath()) and
  conf.isSanitizerGuard(guard) and
  guard.controlsBlock(node.getBasicBlock(), branch)
}

query predicate sanitizerGuardedNode(
  TestTaintTrackingConfiguration conf, DataFlow::BarrierGuard guard, DataFlow::ExprNode node
) {
  exists(guard.getLocation().getFile().getRelativePath()) and
  conf.isSanitizerGuard(guard) and
  node = guard.getAGuardedNode()
}
