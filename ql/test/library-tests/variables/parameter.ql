import codeql_ruby.ast.Variable

query predicate parameter(Parameter p, Variable v) { p.getAnAccess().getVariable() = v }

query predicate parameterNoAcess(Parameter p) { not exists(p.getAnAccess()) }
