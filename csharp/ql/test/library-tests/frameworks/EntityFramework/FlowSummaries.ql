import semmle.code.csharp.frameworks.EntityFramework::EntityFramework
import shared.FlowSummaries

private class IncludeEFSummarizedCallable extends IncludeSummarizedCallable {
  IncludeEFSummarizedCallable() { this instanceof EFSummarizedCallable }
}
