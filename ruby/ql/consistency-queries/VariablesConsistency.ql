import codeql.ruby.ast.Variable

query predicate ambiguousVariable(VariableAccess access, Variable variable) {
  access.getVariable() = variable and
  count(access.getVariable()) > 1
}
