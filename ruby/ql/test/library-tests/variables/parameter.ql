import codeql.ruby.ast.Variable
import codeql.ruby.ast.Parameter

query predicate parameterVariable(Parameter p, Variable v) { v = p.getAVariable() }

query predicate parameterNoVariable(Parameter p) { not exists(p.getAVariable()) }

query predicate parameterVariableNoAccess(Parameter p, Variable v) {
  v = p.getAVariable() and strictcount(v.getAnAccess()) = 1
}
