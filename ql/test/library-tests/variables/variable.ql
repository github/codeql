import codeql_ruby.Variables

query predicate variable(Variable v) { any() }

query predicate parameter(Parameter p) { any() }

query predicate localVariable(LocalVariable v) { any() }
