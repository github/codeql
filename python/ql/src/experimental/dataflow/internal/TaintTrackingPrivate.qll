private import python
private import TaintTrackingPublic
private import experimental.dataflow.DataFlow
private import experimental.dataflow.internal.DataFlowPrivate

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }

/**
 * Holds if the additional step from `pred` to `succ` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  none()
  // localAdditionalTaintStep(pred, succ)
  // or
  // succ = pred.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
}
