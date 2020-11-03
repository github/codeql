import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.FlowSummary::TestOutput

private class IncludeEFSummarizedCallable extends RelevantSummarizedCallable {
  IncludeEFSummarizedCallable() { this instanceof SummarizedCallable }
}
