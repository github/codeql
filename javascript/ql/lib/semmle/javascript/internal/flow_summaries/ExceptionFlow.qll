/**
 * Contains a summary for propagating exceptions out of callbacks
 */

private import javascript
private import FlowSummaryUtil
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.FlowSummary
private import semmle.javascript.internal.flow_summaries.Promises

private predicate isCallback(DataFlow::SourceNode node) {
  node instanceof DataFlow::FunctionNode
  or
  node instanceof DataFlow::PartialInvokeNode
  or
  exists(DataFlow::SourceNode prev |
    isCallback(prev) and
    DataFlow::argumentPassingStep(_, prev.getALocalUse(), _, node)
  )
}

/**
 * Summary that propagates exceptions out of callbacks back to the caller.
 */
private class ExceptionFlowSummary extends SummarizedCallable {
  ExceptionFlowSummary() { this = "Exception propagator" }

  override DataFlow::CallNode getACall() {
    not exists(result.getACallee()) and
    // Avoid a few common cases where the exception should not propagate back
    not result.getCalleeName() =
      ["then", "catch", "finally", "addEventListener", EventEmitter::on()] and
    not result = promiseConstructorRef().getAnInvocation() and
    // Restrict to cases where a callback is known to flow in, as lambda flow in DataFlowImplCommon blows up otherwise
    isCallback(result.getAnArgument().getALocalSource())
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..].ReturnValue[exception]" and
    output = "ReturnValue[exception]"
  }
}
