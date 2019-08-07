import python

import semmle.python.security.TaintTracking

query predicate edges(TaintedNode fromnode, TaintedNode tonode) {
    fromnode.getASuccessor() = tonode and
    /* Don't record flow past sinks */
    not fromnode.isSink()
}
