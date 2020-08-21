private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.internal.DataFlowPrivate
private import experimental.dataflow.internal.TaintTrackingPublic

/**
 * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo` excluding
 * local data flow steps. That is, `nodeFrom` and `nodeTo` are likely to represent
 * different objects.
 */
predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) { none() }

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }

/**
 * Holds if the additional step from `nodeFrom` to `nodeTo` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  localAdditionalTaintStep(nodeFrom, nodeTo)
  or
  any(AdditionalTaintStep a).step(nodeFrom, nodeTo)
}
