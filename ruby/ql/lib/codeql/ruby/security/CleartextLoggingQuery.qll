/**
 * Provides a taint-tracking configuration for "Clear-text logging of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import CleartextLoggingCustomizations::CleartextLogging
private import CleartextLoggingCustomizations::CleartextLogging as CleartextLogging

/**
 * A taint-tracking configuration for detecting "Clear-text logging of sensitive information".
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CleartextLogging::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof CleartextLogging::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CleartextLogging::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CleartextLogging::isAdditionalTaintStep(nodeFrom, nodeTo)
  }
}
