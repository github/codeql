/**
 * Provides a taint-tracking configuration for reasoning about allocation-size overflow.
 *
 * Note, for performance reasons: only import this file if `AllocationSizeOverflow::Configuration`
 * is needed, otherwise `AllocationSizeOverflowCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about allocation-size overflow.
 */
module AllocationSizeOverflow {
  import AllocationSizeOverflowCustomizations::AllocationSizeOverflow

  /**
   * A taint-tracking configuration for identifying `len(...)` calls whose argument may be large.
   */
  class FindLargeLensConfiguration extends TaintTracking2::Configuration {
    FindLargeLensConfiguration() { this = "AllocationSizeOverflow::FindLargeLens" }

    override predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    override predicate isSink(DataFlow::Node nd) { nd = Builtin::len().getACall().getArgument(0) }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isSanitizer(DataFlow::Node nd) { nd instanceof Sanitizer }
  }

  private DataFlow::CallNode getALargeLenCall() {
    exists(FindLargeLensConfiguration config, DataFlow::Node lenArg | config.hasFlow(_, lenArg) |
      result.getArgument(0) = lenArg
    )
  }

  /**
   * A taint-tracking configuration for identifying allocation-size overflows.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "AllocationSizeOverflow" }

    override predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    /**
     * Holds if `nd` is at a position where overflow might occur, and its result is used to compute
     * allocation size `allocsz`.
     */
    predicate isSink(DataFlow::Node nd, DataFlow::Node allocsz) {
      nd.(Sink).getAllocationSize() = allocsz
    }

    override predicate isSink(DataFlow::Node nd) { isSink(nd, _) }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      additionalStep(pred, succ)
      or
      exists(DataFlow::CallNode c |
        c = getALargeLenCall() and
        pred = c.getArgument(0) and
        succ = c
      )
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isSanitizer(DataFlow::Node nd) { nd instanceof Sanitizer }
  }
}
