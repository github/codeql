/**
 * Provides a taint-tracking configuration for detecting "code execution from deserialization" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserialization::Configuration` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import UnsafeDeserializationCustomizations::UnsafeDeserialization

private module UnsafeDeserializationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "code execution from deserialization" vulnerabilities. */
module UnsafeDeserializationFlow = TaintTracking::Global<UnsafeDeserializationConfig>;
