/**
 * Provides classes that heuristically increase the extent of `TaintTracking::AdditionalTaintStep`.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript

/**
 * A heuristic additional flow step in a security query.
 */
abstract class HeuristicAdditionalTaintStep extends DataFlow::ValueNode { }

/**
 * A call to `tainted.replace(x, y)` that preserves taint.
 */
private class HeuristicStringManipulationTaintStep extends HeuristicAdditionalTaintStep,
  TaintTracking::AdditionalTaintStep, StringReplaceCall {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getReceiver() and succ = this
  }
}
