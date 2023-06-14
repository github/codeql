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
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}
