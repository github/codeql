private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.Sequel

query predicate sequelSqlConstruction(SqlConstruction c, DataFlow::Node sql) { sql = c.getSql() }

query predicate sequelSqlExecution(SqlExecution e, DataFlow::Node sql) { sql = e.getSql() }
