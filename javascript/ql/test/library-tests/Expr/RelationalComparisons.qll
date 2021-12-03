import javascript

query predicate test_RelationalComparisons(RelationalComparison rel, Expr res0, Expr res1) {
  res0 = rel.getLesserOperand() and res1 = rel.getGreaterOperand()
}
