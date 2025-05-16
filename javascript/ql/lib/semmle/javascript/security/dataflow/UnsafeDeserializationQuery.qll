/**
 * Provides a taint-tracking configuration for reasoning about unsafe deserialization.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserialization::Configuration` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

import javascript
import UnsafeDeserializationCustomizations::UnsafeDeserialization

/**
 * A taint-tracking configuration for reasoning about unsafe deserialization.
 */
module UnsafeDeserializationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about unsafe deserialization.
 */
module UnsafeDeserializationFlow = TaintTracking::Global<UnsafeDeserializationConfig>;
