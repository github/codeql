import experimental.dataflow.tainttracking.TestTaintLib

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
