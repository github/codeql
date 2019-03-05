import javascript

class TrackedStringLiteral extends DataFlow::TrackedNode {
  TrackedStringLiteral() { this.asExpr() instanceof ConstantString }
}

query predicate test_query15(DataFlow::Node sink) {
  exists(TrackedStringLiteral source, SsaExplicitDefinition def |
    source.flowsTo(sink) and
    sink = DataFlow::ssaDefinitionNode(def) and
    def.getSourceVariable().getName().toLowerCase() = "password"
  |
    any()
  )
}
