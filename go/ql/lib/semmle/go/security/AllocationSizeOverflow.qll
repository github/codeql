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

  private module FindLargeLensConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    predicate isSink(DataFlow::Node nd) { nd = Builtin::len().getACall().getArgument(0) }

    predicate isBarrier(DataFlow::Node nd) { nd instanceof Sanitizer }
  }

  /**
   * Tracks taint flow to find `len(...)` calls whose argument may be large.
   */
  private module FindLargeLensFlow = TaintTracking::Global<FindLargeLensConfig>;

  private DataFlow::CallNode getALargeLenCall() {
    exists(DataFlow::Node lenArg | FindLargeLensFlow::flow(_, lenArg) |
      result.getArgument(0) = lenArg
    )
  }

  /**
   * Holds if `nd` is at a position where overflow might occur, and its result is used to compute
   * allocation size `allocsz`.
   */
  predicate isSinkWithAllocationSize(DataFlow::Node nd, DataFlow::Node allocsz) {
    nd.(Sink).getAllocationSize() = allocsz
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { isSinkWithAllocationSize(sink, _) }

    predicate isBarrier(DataFlow::Node nd) { nd instanceof Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      additionalStep(pred, succ)
      or
      exists(DataFlow::CallNode c |
        c = getALargeLenCall() and
        pred = c.getArgument(0) and
        succ = c
      )
    }
  }

  /** Tracks taint flow to find allocation-size overflows. */
  module Flow = TaintTracking::Global<Config>;
}
