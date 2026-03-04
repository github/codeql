private import codeql.php.AST
private import DataFlowPrivate
private import TaintTrackingPrivate
private import codeql.php.DataFlow

/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow in one local step from `nodeFrom` to `nodeTo`.
 */
predicate localTaintStep = localTaintStepCached/2;

cached
private predicate localTaintStepCached(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  DataFlow::localFlowStep(nodeFrom, nodeTo)
  or
  defaultAdditionalTaintStep(nodeFrom, nodeTo, _)
}
