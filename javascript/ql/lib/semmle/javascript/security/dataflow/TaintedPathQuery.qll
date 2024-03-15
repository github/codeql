/**
 * Provides a taint tracking configuration for reasoning about
 * tainted-path vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TaintedPath::Configuration` is needed, otherwise
 * `TaintedPathCustomizations` should be imported instead.
 */

import javascript
private import TaintedPathCustomizations::TaintedPath

// Materialize flow labels
private class ConcretePosixPath extends Label::PosixPath {
  ConcretePosixPath() { this = this }
}

private class ConcreteSplitPath extends Label::SplitPath {
  ConcreteSplitPath() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
 */
module TaintedPathConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel state) {
    state = source.(Source).getAFlowLabel()
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel state) {
    state = sink.(Sink).getAFlowLabel()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    node instanceof Sanitizer and exists(label)
    or
    node = DataFlow::MakeLabeledBarrierGuard<BarrierGuard>::getABarrierNode(label)
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowLabel state1, DataFlow::Node node2,
    DataFlow::FlowLabel state2
  ) {
    isAdditionalTaintedPathFlowStep(node1, node2, state1, state2)
  }
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
