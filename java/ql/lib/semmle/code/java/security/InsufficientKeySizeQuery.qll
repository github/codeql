/** Provides data flow configurations to be used in queries related to insufficient key sizes. */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.InsufficientKeySize

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

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks key sizes used in cryptographic algorithms. */
module KeySizeFlow = DataFlow::GlobalWithState<KeySizeConfig>;
