import codeql_ruby.Variable

query predicate ambiguousVariable(VariableAccess access, Variable variable) {
  access.getVariable() = variable and
  count(access.getVariable()) > 1
}
