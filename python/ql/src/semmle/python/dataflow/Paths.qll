
import semmle.python.security.TaintTracking
private import semmle.python.dataflow.Implementation
private import semmle.python.dataflow.Presentation


query predicate edges(TaintTrackingNode fromnode, TaintTrackingNode tonode) {
    TaintTrackingPresentation::pathEdge(fromnode, tonode, _)
}

