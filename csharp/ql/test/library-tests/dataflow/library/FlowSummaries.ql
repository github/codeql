import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private::TestOutput

private class IncludeSummarizedCallable extends RelevantSummarizedCallable {
  IncludeSummarizedCallable() { this instanceof SummarizedCallable }

  override string getFullString() { result = this.(Callable).getQualifiedNameWithTypes() }
}
