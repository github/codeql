/**
 * Contains implicit read steps at the input to any function that converts a deep object to a string, such as `JSON.stringify`.
 */

private import javascript
private import FlowSummaryUtil
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.FlowSummary

private class JsonStringifySummary extends SummarizedCallable {
  JsonStringifySummary() { this = "JSON.stringify" }

  override DataFlow::InvokeNode getACall() { result instanceof JsonStringifyCall }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = false and
    input = ["Argument[0]", "Argument[0].AnyMemberDeep"] and
    output = "ReturnValue"
  }
}
