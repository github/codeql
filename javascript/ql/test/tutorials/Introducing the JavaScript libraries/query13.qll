import javascript

query predicate test_query13(StrictEqualityTest eq, string res) {
  exists(DataFlow::AnalyzedNode nd, NullLiteral null |
    eq.hasOperands(nd.asExpr(), null) and
    not nd.getAValue().isIndefinite(_) and
    not nd.getAValue() instanceof AbstractNull
  |
    res = "Spurious null check."
  )
}
