import semmle.python.dataflow.Implementation

deprecated module TaintTrackingPaths {
  predicate edge(TaintTrackingNode src, TaintTrackingNode dest, string label) {
    exists(TaintTrackingNode source, TaintTrackingNode sink |
      source.getConfiguration().hasFlowPath(source, sink) and
      source.getASuccessor*() = src and
      src.getASuccessor(label) = dest and
      dest.getASuccessor*() = sink
    )
  }
}

deprecated query predicate edges(TaintTrackingNode fromnode, TaintTrackingNode tonode) {
  TaintTrackingPaths::edge(fromnode, tonode, _)
}
