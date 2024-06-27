/**
 * Provides modeling for `Sequel`, the database toolkit for Ruby.
 * https://github.com/jeremyevans/sequel
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for `Sequel`, the database toolkit for Ruby.
 * https://github.com/jeremyevans/sequel
 */
module Sequel {
  /** Flow Summary for `Sequel`. */
  private class SqlSummary extends SummarizedCallable {
    SqlSummary() { this = "Sequel.connect" }

    override MethodCall getACall() { result = any(SequelConnection c).asExpr().getExpr() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to establish a connection to a database */
  private class SequelConnection extends DataFlow::CallNode {
    SequelConnection() {
      this =
        API::getTopLevelMember("Sequel").getAMethodCall(["connect", "sqlite", "mysql2", "jdbc"])
    }
  }

  /** A call that constructs SQL statements */
  private class SequelConstruction extends SqlConstruction::Range, DataFlow::CallNode {
    DataFlow::Node query;

    SequelConstruction() {
      this = API::getTopLevelMember("Sequel").getAMethodCall("cast") and query = this.getArgument(1)
      or
      this = API::getTopLevelMember("Sequel").getAMethodCall("function") and
      query = this.getArgument(0)
    }

    override DataFlow::Node getSql() { result = query }
  }

  /** A call that executes SQL statements against a database */
  private class SequelExecution extends SqlExecution::Range, DataFlow::CallNode {
    SequelExecution() {
      exists(SequelConnection sequelConnection |
        this =
          sequelConnection
              .getAMethodCall([
                  "execute", "execute_ddl", "execute_dui", "execute_insert", "run", "<<", "fetch",
                  "fetch_rows", "[]", "log_connection_yield"
                ]) or
        this =
          sequelConnection
              .getAMethodCall("dataset")
              .getAMethodCall([
                  "with_sql", "with_sql_all", "with_sql_delete", "with_sql_each", "with_sql_first",
                  "with_sql_insert", "with_sql_single_value", "with_sql_update"
                ])
      )
    }

    override DataFlow::Node getSql() { result = this.getArgument(0) }
  }
}
