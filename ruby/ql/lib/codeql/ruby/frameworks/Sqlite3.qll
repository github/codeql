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
  private API::Node databaseConst() {
    result = API::getTopLevelMember("SQLite3").getMember("Database")
  }

  private API::Node dbInstance() {
    result = databaseConst().getInstance()
    or
    // e.g. SQLite3::Database.new("foo.db") |db| { db.some_method }
    result = databaseConst().getMethod("new").getBlock().getParameter(0)
  }

  /** Gets a method call with a receiver that is a database instance. */
  private DataFlow::CallNode getADatabaseMethodCall(string methodName) {
    result = dbInstance().getAMethodCall(methodName)
  }

  /** A prepared but unexecuted SQL statement. */
  private class PreparedStatement extends DataFlow::CallNode {
    PreparedStatement() { this = getADatabaseMethodCall("prepare") }

    DataFlow::Node getSql() { result = this.getArgument(0) }
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

  /**
   * A call to `SQLite3::Database.quote`, considered as a sanitizer for SQL statements.
   */
  private class SQLite3QuoteSanitization extends SqlSanitization {
    SQLite3QuoteSanitization() {
      this = API::getTopLevelMember("SQLite3").getMember("Database").getAMethodCall("quote")
    }
  }
}
