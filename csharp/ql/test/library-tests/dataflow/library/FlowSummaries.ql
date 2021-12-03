import shared.FlowSummaries

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { this instanceof SummarizedCallable }
}
