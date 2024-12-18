/**
 * Provides modeling for mysql2, a Ruby library (gem) for interacting with MySql databases.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for mysql2, a Ruby library (gem) for interacting with MySql databases.
 */
module Mysql2 {
  /**
   * Flow summary for `Mysql2::Client.new()`.
   */
  private class SqlSummary extends SummarizedCallable {
    SqlSummary() { this = "Mysql2::Client.new()" }

    override MethodCall getACall() { result = any(Mysql2Connection c).asExpr().getExpr() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to Mysql2::Client.new() is used to establish a connection to a MySql database. */
  private class Mysql2Connection extends DataFlow::CallNode {
    Mysql2Connection() {
      this = API::getTopLevelMember("Mysql2").getMember("Client").getAnInstantiation()
    }
  }

  /** A call that executes SQL statements against a MySQL database. */
  private class Mysql2Execution extends SqlExecution::Range, DataFlow::CallNode {
    private DataFlow::Node query;

    Mysql2Execution() {
      exists(Mysql2Connection mysql2Connection |
        this = mysql2Connection.getAMethodCall("query") and query = this.getArgument(0)
        or
        exists(DataFlow::CallNode prepareCall |
          prepareCall = mysql2Connection.getAMethodCall("prepare") and
          query = prepareCall.getArgument(0) and
          this = prepareCall.getAMethodCall("execute")
        )
      )
    }

    override DataFlow::Node getSql() { result = query }
  }

  /**
   * A call to `Mysql2::Client.escape`, considered as a sanitizer for SQL statements.
   */
  private class Mysql2EscapeSanitization extends SqlSanitization::Range {
    Mysql2EscapeSanitization() {
      this = API::getTopLevelMember("Mysql2").getMember("Client").getAMethodCall("escape")
    }
  }

  /**
   * Flow summary for `Mysql2::Client.escape()`.
   */
  private class EscapeSummary extends SummarizedCallable {
    EscapeSummary() { this = "Mysql2::Client.escape()" }

    override MethodCall getACall() { result = any(Mysql2EscapeSanitization c).asExpr().getExpr() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }
}
