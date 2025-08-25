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

private module StackTraceExposureConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting "stack trace exposure" vulnerabilities.
 */
module StackTraceExposureFlow = TaintTracking::Global<StackTraceExposureConfig>;
