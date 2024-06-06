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
    exists(KeySizeState s | source.(InsufficientKeySizeSource).hasState(s) and state = s.toString())
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(KeySizeState s | sink.(InsufficientKeySizeSink).hasState(s) and state = s.toString())
  }
}

/**
 * A data flow configuration for tracking key sizes used in cryptographic algorithms.
 */
module KeySizeConfig implements DataFlow::StateConfigSig {
  class FlowState = KeySizeState;

  predicate isSource(DataFlow::Node source, KeySizeState state) {
    source.(InsufficientKeySizeSource).hasState(state)
  }

  predicate isSink(DataFlow::Node sink, KeySizeState state) {
    sink.(InsufficientKeySizeSink).hasState(state)
  }
}

/** Tracks key sizes used in cryptographic algorithms. */
module KeySizeFlow = DataFlow::GlobalWithState<KeySizeConfig>;
