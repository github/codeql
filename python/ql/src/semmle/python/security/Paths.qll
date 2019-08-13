import python

import semmle.python.security.TaintTracking
private import semmle.python.dataflow.Implementation

private predicate sourceReaches(TaintTrackingNode node) {
    exists(TaintTrackingNode src |
        src.getConfiguration() = node.getConfiguration() and
        src.isSource() and src.getASuccessor*() = node
    )
}

private predicate reachesSink(TaintTrackingNode node) {
    exists(TaintTrackingNode sink |
        sink.getConfiguration() = node.getConfiguration() and
        sink.isSink() and node.getASuccessor*() = sink
    )
}

query predicate edges(TaintTrackingNode fromnode, TaintTrackingNode tonode) {
    sourceReaches(fromnode) and
    reachesSink(tonode) and
    fromnode.getASuccessor() = tonode
}
