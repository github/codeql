import codeql_ruby.Variables

query predicate variableAccess(VariableAccess var, VariableScope scope) {
  scope = var.getVariable().getDeclaringScope()
}

query predicate parameterAccess(ParameterAccess var, VariableScope scope) {
  scope = var.getVariable().getDeclaringScope()
}

query predicate localVariableAccess(LocalVariableAccess var, VariableScope scope) {
  scope = var.getVariable().getDeclaringScope()
}
