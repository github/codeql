private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.Mysql2

query predicate mysql2SqlExecution(SqlExecution e, DataFlow::Node sql) { sql = e.getSql() }
