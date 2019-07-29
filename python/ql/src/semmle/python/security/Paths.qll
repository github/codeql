import python

import semmle.python.security.TaintTracking
private import semmle.python.dataflow.Implementation

query predicate edges(TaintTrackingNode fromnode, TaintTrackingNode tonode) {
    fromnode.getASuccessor() = tonode and
    /* Don't record flow past sinks */
    not fromnode.isSink()
}
