/**
 * Provides a taint-tracking configuration for detecting stack-trace exposure
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StackTraceExposure::Configuration` is needed; otherwise,
 * `StackTraceExposureCustomizations` should be imported instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import StackTraceExposureCustomizations::StackTraceExposure

/**
 * A taint-tracking configuration for detecting "stack trace exposure" vulnerabilities.
 * DEPRECATED: Use `StackTraceExposureFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "StackTraceExposure" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

private module StackTraceExposureConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for detecting "stack trace exposure" vulnerabilities.
 */
module StackTraceExposureFlow = TaintTracking::Global<StackTraceExposureConfig>;
