/**
 * Provides modeling for the `Base64` module.
 */

private import ruby
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.ApiGraphs

private class Base64Decode extends SummarizedCallable {
  Base64Decode() { this = "Base64.decode64()" }

  override MethodCall getACall() {
    result =
      API::getTopLevelMember("Base64")
          .getAMethodCall(["decode64", "strict_decode64", "urlsafe_decode64"])
          .asExpr()
          .getExpr()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = false
  }
}
