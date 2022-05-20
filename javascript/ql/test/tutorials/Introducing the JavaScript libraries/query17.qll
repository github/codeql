import javascript

class PasswordTracker extends DataFlow::Configuration {
  PasswordTracker() {
    // unique identifier for this configuration
    this = "PasswordTracker"
  }

  override predicate isSource(DataFlow::Node nd) { nd.asExpr() instanceof StringLiteral }

  override predicate isSink(DataFlow::Node nd) { passwordVarAssign(_, nd) }

  predicate passwordVarAssign(Variable v, DataFlow::Node nd) {
    exists(SsaExplicitDefinition def |
      nd = DataFlow::ssaDefinitionNode(def) and
      def.getSourceVariable() = v and
      v.getName().toLowerCase() = "password"
    )
  }
}

query predicate test_query17(DataFlow::Node sink, string res) {
  exists(PasswordTracker pt, DataFlow::Node source, Variable v |
    pt.hasFlow(source, sink) and pt.passwordVarAssign(v, sink)
  |
    res = "Password variable " + v.toString() + " is assigned a constant string."
  )
}
