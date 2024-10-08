/**
 * Contains a summary for propagating exceptions out of callbacks
 */

private import javascript
private import FlowSummaryUtil
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.FlowSummary
private import semmle.javascript.internal.flow_summaries.Promises

/**
 * Summary that propagates exceptions out of callbacks back to the caller.
 */
private class ExceptionFlowSummary extends SummarizedCallable {
  ExceptionFlowSummary() { this = "Exception propagator" }

  override DataFlow::CallNode getACall() {
    not exists(result.getACallee()) and
    // Avoid a few common cases where the exception should not propagate back
    not result.getCalleeName() =
      ["then", "catch", "finally", "addEventListener", "addListener", "on", "once"] and
    not result = promiseConstructorRef().getAnInvocation()
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..].ReturnValue[exception]" and
    output = "ReturnValue[exception]"
  }
}
