import codeql_ruby.Variables

query predicate variable(Variable v) { any() }

query predicate parameter(LocalVariable v) { v.getAnAccess() instanceof ParameterAccess }

query predicate localVariable(LocalVariable v) { not v.getAnAccess() instanceof ParameterAccess }
