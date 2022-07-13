/**
 * Provides classes that heuristically increase the extent of `TaintTracking::SharedTaintStep`.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript

/**
 * A call to `tainted.replace(x, y)` that preserves taint.
 */
private class HeuristicStringManipulationTaintStep extends TaintTracking::SharedTaintStep {
  override predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(StringReplaceCall call |
      pred = call.getReceiver() and
      succ = call
    )
  }
}

/** Any call to a library component where we assume taint from any argument to the result */
private class HeuristicLibraryCallTaintStep extends TaintTracking::SharedTaintStep {
  override predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      pred = call.getAnArgument() or // the plain argument
      pred = call.getAnArgument().(DataFlow::SourceNode).getAPropertyWrite().getRhs() // one property down
    |
      succ = call
    )
  }
}
