import codeql_ruby.ast.Variable

query predicate variableAccess(VariableAccess access, Variable variable, VariableScope scope) {
  variable = access.getVariable() and
  scope = variable.getDeclaringScope()
}
