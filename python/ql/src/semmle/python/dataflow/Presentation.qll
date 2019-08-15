import python
private import semmle.python.dataflow.Implementation

/** This module computed the flows from source to sink and edges to present to the user.
 *  Depends on the `Implementation` module to compute taint.
 */

module TaintTrackingPresentation {

    predicate pathEdge(TaintTrackingNode src, TaintTrackingNode dest) {
        pathEdge(src, dest, _)
    }

    predicate pathEdge(TaintTrackingNode src, TaintTrackingNode dest, string label) {
        exists(TaintTrackingNode source, TaintTrackingNode sink |
            source.getConfiguration().hasFlowPath(source, sink) and
            source.getASuccessor*() = src and
            src.getASuccessor(label) = dest and
            dest.getASuccessor*() = sink
        )
    }

}