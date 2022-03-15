import semmle.code.csharp.frameworks.EntityFramework::EntityFramework
import shared.FlowSummaries

private class IncludeEFSummarizedCallable extends RelevantSummarizedCallable {
  IncludeEFSummarizedCallable() { this instanceof EFSummarizedCallable }
}
