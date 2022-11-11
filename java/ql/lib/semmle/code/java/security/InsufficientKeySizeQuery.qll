/** Provides data flow configurations to be used in queries related to insufficient key sizes. */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.InsufficientKeySize

/** A data flow configuration for tracking key sizes used in cryptographic algorithms. */
class KeySizeConfiguration extends DataFlow::Configuration {
  KeySizeConfiguration() { this = "KeySizeConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.(InsufficientKeySizeSource).hasState(state)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink.(InsufficientKeySizeSink).hasState(state)
  }
}
