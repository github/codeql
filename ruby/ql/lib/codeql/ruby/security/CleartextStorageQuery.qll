/**
 * Provides a taint-tracking configuration for "Clear-text storage of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `Configuration` is needed, otherwise `CleartextStorageCustomizations` should be
 * imported instead.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import CleartextStorageCustomizations::CleartextStorage as CleartextStorage

/**
 * A taint-tracking configuration for detecting "Clear-text storage of sensitive information".
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CleartextStorage" }

  override predicate isSource(DataFlow::Node source) { source instanceof CleartextStorage::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CleartextStorage::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof CleartextStorage::Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CleartextStorage::isAdditionalTaintStep(nodeFrom, nodeTo)
  }
}
