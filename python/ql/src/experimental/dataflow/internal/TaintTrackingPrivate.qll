private import python
private import TaintTrackingPublic
private import semmle.code.python.dataflow.DataFlow
private import semmle.code.python.dataflow.internal.DataFlowPrivate

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }

/**
 * Holds if the additional step from `src` to `sink` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  none()
  // localAdditionalTaintStep(pred, succ)
  // or
  // succ = pred.(DataFlow::NonLocalJumpNode).getAJumpSuccessor(false)
}
