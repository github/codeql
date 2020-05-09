/**
 * Provides classes that heuristically increase the extent of `TaintTracking::SharedTaintStep`.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript

/**
 * DEPRECATED.
 *
 * The target of a heuristic additional flow step in a security query.
 */
deprecated class HeuristicAdditionalTaintStep extends DataFlow::Node {
  HeuristicAdditionalTaintStep() { any(TaintTracking::SharedTaintStep step).heuristicStep(_, this) }
}

/**
 * A call to `tainted.replace(x, y)` that preserves taint.
 */
private class HeuristicStringManipulationTaintStep extends TaintTracking::SharedTaintStep {
  override predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "replace" and
      pred = call.getReceiver() and
      succ = call
    )
  }
}
