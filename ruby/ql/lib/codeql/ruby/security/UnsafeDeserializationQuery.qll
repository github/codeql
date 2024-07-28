/**
 * Provides a taint-tracking configuration for reasoning about unsafe deserialization.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserializationFlow` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import UnsafeDeserializationCustomizations

/**
 * A taint-tracking configuration for reasoning about unsafe deserialization.
 * DEPRECATED: Use `UnsafeDeserializationFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeDeserialization" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UnsafeDeserialization::Source
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserialization::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof UnsafeDeserialization::Sanitizer
  }
}

private module UnsafeDeserializationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UnsafeDeserialization::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserialization::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof UnsafeDeserialization::Sanitizer }
}

/**
 * Taint-tracking for reasoning about unsafe deserialization.
 */
module UnsafeCodeConstructionFlow = TaintTracking::Global<UnsafeDeserializationConfig>;
