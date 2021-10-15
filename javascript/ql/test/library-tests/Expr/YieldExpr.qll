import javascript

query predicate test_YieldExpr(YieldExpr yield, string s) {
  if yield.isDelegating() then s = "delegating" else s = "not delegating"
}
