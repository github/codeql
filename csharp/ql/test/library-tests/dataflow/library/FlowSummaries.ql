import shared.FlowSummaries
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { this instanceof FlowSummaryImpl::Public::SummarizedCallable }
}
