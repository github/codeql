import javascript

module PasswordConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node nd) { nd.asExpr() instanceof StringLiteral }

  predicate isSink(DataFlow::Node nd) { passwordVarAssign(_, nd) }
}

predicate passwordVarAssign(Variable v, DataFlow::Node nd) {
  v.getAnAssignedExpr() = nd.asExpr() and
  v.getName().toLowerCase() = "password"
}

module PasswordFlow = DataFlow::Global<PasswordConfig>;

query predicate test_query17(DataFlow::Node sink, string res) {
  exists(Variable v | PasswordFlow::flow(_, sink) and passwordVarAssign(v, sink) |
    res = "Password variable " + v.toString() + " is assigned a constant string."
  )
}
