/**
 * Provides a taint-tracking configuration for "Clear-text storage of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `Configuration` is needed, otherwise `CleartextStorageCustomizations` should be
 * imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import CleartextStorageCustomizations::CleartextStorage as CleartextStorage

/**
 * A taint-tracking configuration for detecting "Clear-text storage of sensitive information".
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CleartextStorage::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof CleartextStorage::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CleartextStorage::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CleartextStorage::isAdditionalTaintStep(nodeFrom, nodeTo)
  }
}
