private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.internal.ExternalFlow
import shared.FlowSummaries

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { exists(this) }
}

private class IncludeNeutralSummarizedCallable extends RelevantNeutralCallable instanceof FlowSummaryImpl::Public::NeutralSummaryCallable
{
  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() { result = asPartialNeutralModel(this) }
}
