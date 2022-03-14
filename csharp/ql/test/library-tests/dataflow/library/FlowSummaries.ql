import semmle.code.csharp.dataflow.internal.FlowSummaries

private class IncludeAllSummarizedCallable extends IncludeSummarizedCallable {
  IncludeAllSummarizedCallable() { this instanceof SummarizedCallable }
}
