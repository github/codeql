/**
 * Provides a taint-tracking configuration for reasoning about unsafe deserialization.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserialization::Configuration` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import UnsafeDeserializationCustomizations

/**
 * A taint-tracking configuration for reasoning about unsafe deserialization.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeDeserialization" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UnsafeDeserialization::Source
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserialization::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof UnsafeDeserialization::Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    UnsafeDeserialization::isAdditionalTaintStep(fromNode, toNode)
  }
}
