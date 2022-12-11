private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import shared.FlowSummaries

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { exists(this) }
}

private class IncludeNegativeSummarizedCallable extends RelevantNegativeSummarizedCallable instanceof FlowSummaryImpl::Public::NegativeSummarizedCallable {
  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() { result = Csv::asPartialNegativeModel(this) }
}
