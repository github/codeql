import javascript

query predicate test_JumpTargets(BreakOrContinueStmt boc, string label, Stmt res) {
  (if boc.hasTargetLabel() then label = boc.getTargetLabel() else label = "(none)") and
  res = boc.getTarget()
}
