import codeql_ruby.ast.Variable

query predicate parameterVariable(Parameter p, Variable v) { v = p.getAVariable() }

query predicate parameterVariableAccess(Parameter p, Variable v, VariableAccess va) {
  v = p.getAVariable() and
  va = v.getAnAccess()
}

query predicate parameterVariableNoAcess(Parameter p, Variable v) {
  v = p.getAVariable() and not exists(v.getAnAccess())
}
