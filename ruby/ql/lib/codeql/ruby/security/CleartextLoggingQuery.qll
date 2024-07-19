/**
 * Provides a taint-tracking configuration for "Clear-text logging of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLoggingFlow` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import CleartextLoggingCustomizations::CleartextLogging
private import CleartextLoggingCustomizations::CleartextLogging as CL

/**
 * A taint-tracking configuration for detecting "Clear-text logging of sensitive information".
 * DEPRECATED: Use `CleartextLoggingFlow` instead
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CleartextLogging" }

  override predicate isSource(DataFlow::Node source) { source instanceof CL::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CL::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof CL::Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CL::isAdditionalTaintStep(nodeFrom, nodeTo)
  }
}

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof CL::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof CL::Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CL::Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CL::isAdditionalTaintStep(nodeFrom, nodeTo)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet cs) {
    cs.isAny() and
    isSink(node)
  }
}

/**
 * Taint-tracking for detecting "Clear-text logging of sensitive information".
 */
module CleartextLoggingFlow = TaintTracking::Global<Config>;
