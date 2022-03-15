import shared.FlowSummaries

private class IncludeAllSummarizedCallable extends RelevantSummarizedCallable {
  IncludeAllSummarizedCallable() { this instanceof SummarizedCallable }
}
