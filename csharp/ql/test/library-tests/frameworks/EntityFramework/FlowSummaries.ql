import semmle.code.csharp.dataflow.FlowSummary
import semmle.code.csharp.dataflow.internal.FlowSummaryImpl::Private::TestOutput
import semmle.code.csharp.frameworks.EntityFramework::EntityFramework

private class IncludeSummarizedCallable extends RelevantSummarizedCallable {
  IncludeSummarizedCallable() { this instanceof EFSummarizedCallable }

  override string getFullString() { result = this.(Callable).getQualifiedNameWithTypes() }
}
