/**
 * Provides a taint tracking configuration for reasoning about unsafe
 * zip and tar archive extraction.
 *
 * Note, for performance reasons: only import this file if
 * `ZipSlip::Configuration` is needed, otherwise
 * `ZipSlipCustomizations` should be imported instead.
 */

import javascript

module ZipSlip {
  import ZipSlipCustomizations::ZipSlip

  /** A taint tracking configuration for unsafe archive extraction. */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "ZipSlip" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      label = source.(Source).getAFlowLabel()
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      label = sink.(Sink).getAFlowLabel()
    }

    override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node) or
      node instanceof TaintedPath::Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      guard instanceof TaintedPath::BarrierGuardNode
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      TaintedPath::isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
    }
  }
}
