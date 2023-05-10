/**
 * Provides modeling for `sqlite3`, a library that allows Ruby programs to use the SQLite3 database engine.
 * Version: 1.6.2
 * https://github.com/sparklemotion/sqlite3-ruby
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for `sqlite3`, a library that allows Ruby programs to use the SQLite3 database engine.
 * Version: 1.6.2
 * https://github.com/sparklemotion/sqlite3-ruby
 */
module Sqlite3 {
  /** Gets a method call with a receiver that is a database instance. */
  private DataFlow::CallNode getADatabaseMethodCall(string methodName) {
    exists(API::Node dbInstance |
      dbInstance = API::getTopLevelMember("SQLite3").getMember("Database").getInstance() and
      (
        result = dbInstance.getAMethodCall(methodName)
        or
        // e.g. SQLite3::Database.new("foo.db") |db| { db.some_method }
        exists(DataFlow::BlockNode block |
          result.getMethodName() = methodName and
          block = dbInstance.getAValueReachableFromSource().(DataFlow::CallNode).getBlock() and
          block.getParameter(0).flowsTo(result.getReceiver())
        )
      )
    )
  }

  /** A prepared but unexecuted SQL statement. */
  private class PreparedStatement extends SqlConstruction::Range, DataFlow::CallNode {
    PreparedStatement() { this = getADatabaseMethodCall("prepare") }

    override DataFlow::Node getSql() { result = this.getArgument(0) }
  }

  /** Execution of a prepared SQL statement. */
  private class PreparedStatementExecution extends SqlExecution::Range, DataFlow::CallNode {
    private PreparedStatement stmt;

    PreparedStatementExecution() {
      stmt.flowsTo(this.getReceiver()) and
      this.getMethodName() = ["columns", "execute", "execute!", "get_metadata", "types"]
    }

    override DataFlow::Node getSql() { result = stmt.getReceiver() }
  }

  /** Gets the name of a method called against a database that executes an SQL statement. */
  private string getAnExecutionMethodName() {
    result =
      [
        "execute", "execute2", "execute_batch", "execute_batch2", "get_first_row",
        "get_first_value", "query"
      ]
  }

  /** A method call against a database that constructs an SQL query. */
  private class DatabaseMethodCallSqlConstruction extends SqlConstruction::Range, DataFlow::CallNode
  {
    // Database query execution methods also construct an SQL query
    DatabaseMethodCallSqlConstruction() {
      this = getADatabaseMethodCall(getAnExecutionMethodName())
    }

    override DataFlow::Node getSql() { result = this.getArgument(0) }
  }

  /** A method call against a database that executes an SQL query. */
  private class DatabaseMethodCallSqlExecution extends SqlExecution::Range, DataFlow::CallNode {
    DatabaseMethodCallSqlExecution() { this = getADatabaseMethodCall(getAnExecutionMethodName()) }

    override DataFlow::Node getSql() { result = this.getArgument(0) }
  }
}
