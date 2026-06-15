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
deprecated private class ConcretePosixPath extends TaintedPath::Label::PosixPath {
  ConcretePosixPath() { this = this }
}

deprecated private class ConcreteSplitPath extends TaintedPath::Label::SplitPath {
  ConcreteSplitPath() { this = this }
}

/** A taint tracking configuration for unsafe archive extraction. */
module ZipSlipConfig implements DataFlow::StateConfigSig {
  class FlowState = TaintedPath::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = source.(Source).getAFlowState()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { state = sink.(Sink).getAFlowState() }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof TaintedPath::Sanitizer or
    node = DataFlow::MakeBarrierGuard<TaintedPath::BarrierGuard>::getABarrierNode()
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node =
      DataFlow::MakeStateBarrierGuard<FlowState, TaintedPath::BarrierGuard>::getABarrierNode(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedPath::isAdditionalFlowStep(node1, state1, node2, state2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
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
    ZipSlipConfig::isAdditionalFlowStep(src, TaintedPath::FlowState::fromFlowLabel(srclabel), dst,
      TaintedPath::FlowState::fromFlowLabel(dstlabel))
  }
}
