/**
 * @name Debug summarized callable
 * @description Renders the data flow graph for a summarized callable
 * @kind graph
 * @id unified/debug-summarized-callable
 */

private import unified
private import codeql.unified.internal.dataflow.AllDataFlow
import FlowSummaryOutput::RenderSummarizedCallable

predicate showCallable(SummarizedCallable callable) { callable.getTypeString() = "TestType" }

class DebugCallable extends RelevantSummarizedCallable {
  DebugCallable() { showCallable(this) }
}
