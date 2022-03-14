import semmle.code.csharp.frameworks.EntityFramework::EntityFramework
import semmle.code.csharp.dataflow.internal.FlowSummaries

private class IncludeEFSummarizedCallable extends IncludeSummarizedCallable {
  IncludeEFSummarizedCallable() { this instanceof EFSummarizedCallable }
}
