/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

private import python
private import TaintTrackingPrivate
private import semmle.python.dataflow.new.DataFlow
// Need to import since frameworks can extend `AdditionalTaintStep`
private import semmle.python.Frameworks

// Local taint flow and helpers
/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more local (intra-procedural)
 * steps.
 */
pragma[inline]
predicate localExprTaint(Expr e1, Expr e2) {
  localTaint(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // Ordinary data flow
  DataFlow::localFlowStep(nodeFrom, nodeTo)
  or
  localAdditionalTaintStep(nodeFrom, nodeTo, _)
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `nodeFrom` to `nodeTo` should be considered a taint
   * step for all configurations.
   *
   * Note that it is now possible to also specify provenance of the taint step
   * by overwriting `step/3`.
   */
  predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) { none() }

  /**
   * Holds if the step from `nodeFrom` to `nodeTo` should be considered a taint
   * step with provenance `model` for all configurations.
   */
  predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) { none() }

  /**
   * Holds if this `AdditionalTaintStep` defines a step from `nodeFrom` to `nodeTo`
   * with provenance `model`.
   */
  final predicate hasStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    this.step(nodeFrom, nodeTo) and model = "AdditionalTaintStep"
    or
    this.step(nodeFrom, nodeTo, model)
  }
}
