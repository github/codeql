import codeql_ruby.ast.Variable

query predicate variableAccess(VariableAccess access, Variable variable, VariableScope scope) {
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}

query predicate parameterAccess(ParameterAccess access, LocalVariable variable, VariableScope scope) {
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}

query predicate localVariableAccess(
  VariableAccess access, LocalVariable variable, VariableScope scope
) {
  not access instanceof ParameterAccess and
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}
