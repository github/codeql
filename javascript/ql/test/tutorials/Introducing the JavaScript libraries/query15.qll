import javascript

DataFlow::Node constantString(DataFlow::TypeTracker t) {
  t.start() and
  result.asExpr() instanceof ConstantString
  or
  exists(DataFlow::TypeTracker t2 | t = t2.smallstep(constantString(t2), result))
}

query predicate test_query15(DataFlow::Node sink) {
  exists(SsaExplicitDefinition def |
    sink = constantString(DataFlow::TypeTracker::end()) and
    sink = DataFlow::ssaDefinitionNode(def) and
    def.getSourceVariable().getName().toLowerCase() = "password"
  |
    any()
  )
}
