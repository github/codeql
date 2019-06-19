import python

import semmle.python.security.TaintTracking

query predicate edges(TaintedNode fromnode, TaintedNode tonode) {
    fromnode.getASuccessor() = tonode and
    /* Don't record flow past sinks */
    not fromnode.isVulnerableSink()
}

private TaintedNode first_child(TaintedNode parent) {
    result.getContext().getCaller() = parent.getContext() and
    edges(parent, result)
}

private TaintedNode next_sibling(TaintedNode child) {
    edges(child, result) and
    child.getContext() = result.getContext()
}

query predicate parents(TaintedNode child, TaintedNode parent) {
    child = first_child(parent) or
    exists(TaintedNode prev |
        parents(prev, parent) and
        child = next_sibling(prev)
    )
}
