import codeql_ruby.ast.Variable

query predicate parameter(NamedParameter p, Variable v) { p.getAnAccess().getVariable() = v }

query predicate parameterNoAcess(NamedParameter p) { not exists(p.getAnAccess()) }
