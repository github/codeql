import csharp
import shared.FlowSummaries
import semmle.code.csharp.frameworks.EntityFramework::EntityFramework
import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow

class RelevantSummarizedCallable extends IncludeSummarizedCallable instanceof EFSummarizedCallable {
}

import TestSummaryOutput<RelevantSummarizedCallable>

query predicate sourceNode(DataFlow::Node node, string kind) {
  ExternalFlow::sourceNode(node, kind)
}

query predicate sinkNode(DataFlow::Node node, string kind) { ExternalFlow::sinkNode(node, kind) }
