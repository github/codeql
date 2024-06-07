/**
 * Provides modeling for Pg, a Ruby library (gem) for interacting with PostgreSQL databases.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for Pg, a Ruby library (gem) for interacting with PostgreSQL databases.
 */
module Pg {
  /**
   * Flow summary for `PG.new()`. This method initializes a database connection.
   */
  private class SqlSummary extends SummarizedCallable {
    SqlSummary() { this = "PG.new()" }

    override MethodCall getACall() { result = any(PgConnection c).asExpr().getExpr() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to PG::Connection.open() is used to establish a connection to a PostgreSQL database. */
  private class PgConnection extends DataFlow::CallNode {
    PgConnection() {
      this =
        API::getTopLevelMember("PG")
            .getMember("Connection")
            .getAMethodCall(["open", "new", "connect_start"])
      or
      this = API::getTopLevelMember("PG").getAnInstantiation()
    }
  }

  /** A call that prepares an SQL statement to be executed later. */
  private class PgPrepareCall extends SqlConstruction::Range, DataFlow::CallNode {
    private DataFlow::Node query;
    private PgConnection pgConnection;
    private string queryName;

    PgPrepareCall() {
      this = pgConnection.getAMethodCall("prepare") and
      queryName = this.getArgument(0).getConstantValue().getStringlikeValue() and
      query = this.getArgument(1)
    }

    PgConnection getConnection() { result = pgConnection }

    string getQueryName() { result = queryName }

    override DataFlow::Node getSql() { result = query }
  }

  /** A call that executes SQL statements against a PostgreSQL database. */
  private class PgExecution extends SqlExecution::Range, DataFlow::CallNode {
    private DataFlow::Node query;

    PgExecution() {
      exists(PgConnection pgConnection |
        this =
          pgConnection.getAMethodCall(["exec", "async_exec", "exec_params", "async_exec_params"]) and
        query = this.getArgument(0)
        or
        exists(PgPrepareCall prepareCall |
          pgConnection = prepareCall.getConnection() and
          this.getArgument(0).getConstantValue().isStringlikeValue(prepareCall.getQueryName()) and
          query = prepareCall.getSql()
        )
      )
    }

    override DataFlow::Node getSql() { result = query }
  }
}
