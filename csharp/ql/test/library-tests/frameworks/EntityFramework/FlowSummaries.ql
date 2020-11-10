import semmle.code.csharp.dataflow.FlowSummary::TestOutput
import semmle.code.csharp.frameworks.EntityFramework::EntityFramework

private class IncludeEFSummarizedCallable extends RelevantSummarizedCallable {
  IncludeEFSummarizedCallable() { this instanceof EFSummarizedCallable }
}
