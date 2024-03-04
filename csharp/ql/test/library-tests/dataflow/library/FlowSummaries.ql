import shared.FlowSummaries
import semmle.code.csharp.dataflow.internal.ExternalFlow

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { exists(this) }
}

private class IncludeNeutralSummarizedCallable extends RelevantNeutralCallable {
  /** Gets a string representing the callable in semi-colon separated format for use in flow summaries. */
  final override string getCallableCsv() { result = asPartialNeutralModel(this) }
}
