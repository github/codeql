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
   * DEPRECATED: Use copies of `FindLargeLensConfig` and `FindLargeLensFlow` instead.
   *
   * A taint-tracking configuration for identifying `len(...)` calls whose argument may be large.
   */
  deprecated class FindLargeLensConfiguration extends TaintTracking2::Configuration {
    FindLargeLensConfiguration() { this = "AllocationSizeOverflow::FindLargeLens" }

    override predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    override predicate isSink(DataFlow::Node nd) { nd = Builtin::len().getACall().getArgument(0) }

    override predicate isSanitizer(DataFlow::Node nd) { nd instanceof Sanitizer }
  }

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
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for identifying allocation-size overflows.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "AllocationSizeOverflow" }

    override predicate isSource(DataFlow::Node nd) { nd instanceof Source }

    /**
     * Holds if `nd` is at a position where overflow might occur, and its result is used to compute
     * allocation size `allocsz`.
     */
    predicate isSinkWithAllocationSize(DataFlow::Node nd, DataFlow::Node allocsz) {
      nd.(Sink).getAllocationSize() = allocsz
    }

    override predicate isSink(DataFlow::Node nd) { this.isSinkWithAllocationSize(nd, _) }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      additionalStep(pred, succ)
      or
      exists(DataFlow::CallNode c |
        c = getALargeLenCall() and
        pred = c.getArgument(0) and
        succ = c
      )
    }

    override predicate isSanitizer(DataFlow::Node nd) { nd instanceof Sanitizer }
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
