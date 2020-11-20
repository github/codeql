import codeql_ruby.Variables

query predicate variableAccess(VariableAccess access, Variable variable, VariableScope scope) {
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}

query predicate parameterAccess(ParameterAccess access, Parameter variable, VariableScope scope) {
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}

query predicate localVariableAccess(
  LocalVariableAccess access, LocalVariable variable, VariableScope scope
) {
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}
