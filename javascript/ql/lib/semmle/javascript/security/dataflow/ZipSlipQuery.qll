/**
 * Provides a taint tracking configuration for reasoning about unsafe
 * zip and tar archive extraction.
 *
 * Note, for performance reasons: only import this file if
 * `ZipSlip::Configuration` is needed, otherwise
 * `ZipSlipCustomizations` should be imported instead.
 */

import javascript
import ZipSlipCustomizations::ZipSlip

// Materialize flow labels
private class ConcretePosixPath extends TaintedPath::Label::PosixPath {
  ConcretePosixPath() { this = this }
}

private class ConcreteSplitPath extends TaintedPath::Label::SplitPath {
  ConcreteSplitPath() { this = this }
}

/** A taint tracking configuration for unsafe archive extraction. */
module ZipSlipConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    label = source.(Source).getAFlowLabel()
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    label = sink.(Sink).getAFlowLabel()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof TaintedPath::Sanitizer or
    node = DataFlow::MakeBarrierGuard<TaintedPath::BarrierGuard>::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    node = DataFlow::MakeLabeledBarrierGuard<TaintedPath::BarrierGuard>::getABarrierNode(label)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowLabel state1, DataFlow::Node node2,
    DataFlow::FlowLabel state2
  ) {
    TaintedPath::isAdditionalTaintedPathFlowStep(node1, node2, state1, state2)
  }
}

/** A taint tracking configuration for unsafe archive extraction. */
module ZipSlipFlow = DataFlow::GlobalWithState<ZipSlipConfig>;

/** A taint tracking configuration for unsafe archive extraction. */
deprecated class Configuration extends DataFlow::Configuration {
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
    ZipSlipConfig::isAdditionalFlowStep(src, srclabel, dst, dstlabel)
  }
}
