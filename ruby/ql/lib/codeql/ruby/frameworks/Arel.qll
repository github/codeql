/**
 * Provides modeling for Arel, a low level SQL library that powers ActiveRecord.
 * Version: 7.0.3
 * https://api.rubyonrails.org/classes/Arel.html
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary

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

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }
}
