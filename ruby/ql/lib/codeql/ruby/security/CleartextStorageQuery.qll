/**
 * Provides a taint-tracking configuration for "Clear-text storage of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `CleartextStorageFlow` is needed, otherwise
 * `CleartextStorageCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import CleartextStorageCustomizations::CleartextStorage as CS

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CS::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof CS::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CS::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CS::isAdditionalTaintStep(nodeFrom, nodeTo)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet cs) {
    cs.isAny() and
    isSink(node)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting "Clear-text storage of sensitive information".
 */
module CleartextStorageFlow = TaintTracking::Global<Config>;
