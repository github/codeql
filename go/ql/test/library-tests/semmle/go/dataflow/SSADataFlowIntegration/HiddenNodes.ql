/**
 * @kind path-problem
 */

import go

private predicate inTestCallable(DataFlow::Node node) {
  node.getRoot().getEnclosingFunction*().(FuncDecl).getFunction().getName() =
    ["readMerge", "writeMerge", "loop", "capturedWrite", "capturedRead", "uncertainUpdate"]
}

private predicate sourceNode(DataFlow::Node node) {
  node.(DataFlow::CallNode).getTarget().getName() = "source" and
  inTestCallable(node)
}

private predicate sinkNode(DataFlow::Node node) {
  node = any(DataFlow::CallNode call | call.getTarget().getName() = "sink").getArgument(0) and
  inTestCallable(node)
}

module NeverSkipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { sourceNode(node) }

  predicate isSink(DataFlow::Node node) { sinkNode(node) }

  predicate neverSkip(DataFlow::Node node) { any() }
}

module NeverSkipFlow = DataFlow::Global<NeverSkipConfig>;

import NeverSkipFlow::PathGraph

from NeverSkipFlow::PathNode source, NeverSkipFlow::PathNode sink
where NeverSkipFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "neverSkip"
