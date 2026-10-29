import csharp

private string getConditionValue(ConditionalDirective d) {
  if d.conditionMatched() then result = "true" else result = "false"
}

private string getBranchValue(BranchDirective d) {
  if d.branchTaken() then result = "taken" else result = "not taken"
}

query predicate ifDirectives(
  IfDirective d, EndifDirective endif, string taken, string condValue, Expr expr
) {
  d.getEndifDirective() = endif and
  d.getCondition() = expr and
  taken = getBranchValue(d) and
  condValue = getConditionValue(d)
}

query predicate siblings(IfDirective d, BranchDirective sibling, int index, string taken) {
  d.getSiblingDirective(index) = sibling and
  taken = getBranchValue(sibling)
}

query predicate conditionalDirectives(
  ConditionalDirective cond, string taken, string condValue, Expr expr
) {
  cond.getCondition() = expr and
  taken = getBranchValue(cond) and
  condValue = getConditionValue(cond)
}

query predicate expressions(Expr e) { e.getParent+() instanceof ConditionalDirective }
