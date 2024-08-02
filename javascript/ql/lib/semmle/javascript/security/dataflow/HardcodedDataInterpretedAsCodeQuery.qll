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

/**
 * A taint-tracking configuration for reasoning about hard-coded data
 * being interpreted as code
 */
module HardcodedDataInterpretedAsCodeConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel lbl) {
    source.(Source).getLabel() = lbl
  }

  predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) { nd.(Sink).getLabel() = lbl }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowLabel state1, DataFlow::Node node2,
    DataFlow::FlowLabel state2
  ) {
    TaintTracking::defaultTaintStep(node1, node2) and
    state1.isDataOrTaint() and
    state2.isTaint()
  }
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
