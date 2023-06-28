private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.security.SqlInjectionCustomizations

query predicate sinks(SqlInjection::Sink sink) { any() }
