/** Provides data flow configurations to be used in queries related to insufficient key sizes. */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.InsufficientKeySize

/**
 * DEPRECATED: Use `KeySizeFlow` instead.
 *
 * A data flow configuration for tracking key sizes used in cryptographic algorithms.
 */
deprecated class KeySizeConfiguration extends DataFlow::Configuration {
  KeySizeConfiguration() { this = "KeySizeConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.(InsufficientKeySizeSource).hasState(state)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink.(InsufficientKeySizeSink).hasState(state)
  }
}

/**
 * A data flow configuration for tracking key sizes used in cryptographic algorithms.
 */
module KeySizeConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.(InsufficientKeySizeSource).hasState(state)
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink.(InsufficientKeySizeSink).hasState(state)
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }
}

/** Tracks key sizes used in cryptographic algorithms. */
module KeySizeFlow = DataFlow::GlobalWithState<KeySizeConfig>;
