/**
 * Provides a taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code.
 *
 * Note, for performance reasons: only import this file if
 * `HardcodedDataInterpretedAsCode::Configuration` is needed,
 * otherwise `HardcodedDataInterpretedAsCodeCustomizations` should be
 * imported instead.
 */

import javascript
import HardcodedDataInterpretedAsCodeCustomizations::HardcodedDataInterpretedAsCode
private import HardcodedDataInterpretedAsCodeCustomizations::HardcodedDataInterpretedAsCode as HardcodedDataInterpretedAsCode

/**
 * A taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code
 */
module HardcodedDataInterpretedAsCodeConfig implements DataFlow::StateConfigSig {
  class FlowState = HardcodedDataInterpretedAsCode::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source.(Source).getAFlowState() = state
  }

  predicate isSink(DataFlow::Node nd, FlowState state) { nd.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintTracking::defaultTaintStep(node1, node2) and
    state1 = [FlowState::modified(), FlowState::unmodified()] and
    state2 = FlowState::modified()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about hard-coded data being interpreted as code
 */
module HardcodedDataInterpretedAsCodeFlow =
  DataFlow::GlobalWithState<HardcodedDataInterpretedAsCodeConfig>;

/**
 * DEPRECATED. Use the `HardcodedDataInterpretedAsCodeFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "HardcodedDataInterpretedAsCode" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    source.(Source).getLabel() = lbl
  }

  override predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    nd.(Sink).getLabel() = lbl
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
