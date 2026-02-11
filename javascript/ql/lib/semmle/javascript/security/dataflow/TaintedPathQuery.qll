/**
 * Provides a taint tracking configuration for reasoning about
 * tainted-path vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TaintedPath::Configuration` is needed, otherwise
 * `TaintedPathCustomizations` should be imported instead.
 */

import javascript
private import TaintedPathCustomizations
private import TaintedPathCustomizations::TaintedPath

// Materialize flow labels
deprecated private class ConcretePosixPath extends Label::PosixPath {
  ConcretePosixPath() { this = this }
}

deprecated private class ConcreteSplitPath extends Label::SplitPath {
  ConcreteSplitPath() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
 */
module TaintedPathConfig implements DataFlow::StateConfigSig {
  class FlowState = TaintedPath::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = source.(Source).getAFlowState()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) { state = sink.(Sink).getAFlowState() }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node instanceof Sanitizer and exists(state)
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state)
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedPath::isAdditionalFlowStep(node1, state1, node2, state2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about tainted-path vulnerabilities.
 */
module TaintedPathFlow = DataFlow::GlobalWithState<TaintedPathConfig>;

/**
 * DEPRECATED. Use the `TaintedPathFlow` module instead.
 */
deprecated class Configuration extends DataFlow::Configuration {
  Configuration() { this = "TaintedPath" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    label = source.(Source).getAFlowLabel()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    label = sink.(Sink).getAFlowLabel()
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    node instanceof Sanitizer
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof BarrierGuardNode
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
  }
}
