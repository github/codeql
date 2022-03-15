import semmle.code.csharp.dataflow.internal.FlowSummaries

private class IncludeAllSummarizedCallable extends PublicSummarizedCallable {
  IncludeAllSummarizedCallable() { this instanceof SummarizedCallable }
}
