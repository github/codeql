/**
 * Provides modeling for the `Utils` component of the `Rack` library.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary

/**
 * Provides modeling for the `Utils` component of the `Rack` library.
 */
module Utils {
  /** Flow summary for `Rack::Utils.parse_query`, which parses a query string. */
  private class ParseQuerySummary extends SummarizedCallable {
    ParseQuerySummary() { this = "Rack::Utils.parse_query" }

    override MethodCall getACall() {
      result =
        API::getTopLevelMember("Rack")
            .getMember("Utils")
            .getAMethodCall("parse_query")
            .asExpr()
            .getExpr()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = false
    }
  }
}
