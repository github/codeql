import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate sqlConstructions(SqlConstruction c, DataFlow::Node sql) { sql = c.getSql() }
