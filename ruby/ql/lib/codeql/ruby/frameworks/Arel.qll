/**
 * Provides modeling for Arel, a low level SQL library that powers ActiveRecord.
 * Version: 7.0.3
 * https://api.rubyonrails.org/classes/Arel.html
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides modeling for Arel, a low level SQL library that powers ActiveRecord.
 * Version: 7.0.3
 * https://api.rubyonrails.org/classes/Arel.html
 */
module Arel {
  /**
   * Flow summary for `Arel.sql`. This method wraps a SQL string, marking it as
   * safe.
   */
  private class SqlSummary extends SummarizedCallable {
    SqlSummary() { this = "Arel.sql" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Arel").getAMethodCall("sql").asExpr().getExpr()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /** A call to `Arel.sql`, considered as a SQL construction. */
  private class ArelSqlConstruction extends SqlConstruction::Range, DataFlow::CallNode {
    ArelSqlConstruction() {
      this = DataFlow::getConstant("Arel").getAMethodCall() and
      this.getMethodName() = "sql"
    }

    override DataFlow::Node getSql() { result = this.getArgument(0) }
  }
}
