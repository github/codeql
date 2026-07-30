/**
 * Contains utility functions for writing data flow queries
 */

private import python
private import DataFlowPrivate
import DataFlowPublic
private import FlowSummaryImpl as FlowSummaryImpl

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  simpleLocalFlowStep(nodeFrom, nodeTo, _)
  or
  // Simple flow through library code is included in the exposed local
  // step relation, even though flow is technically inter-procedural.
  // This is a convention followed across languages.
  FlowSummaryImpl::Private::Steps::summaryThroughStepValue(nodeFrom, nodeTo, _)
}

private predicate localFlowStepPlus(Node node1, Node node2) = fastTC(localFlowStep/2)(node1, node2)

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localFlow(Node source, Node sink) { source = sink or localFlowStepPlus(source, sink) }
