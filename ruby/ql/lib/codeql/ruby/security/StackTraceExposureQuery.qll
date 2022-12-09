/**
 * Provides a taint-tracking configuration for detecting stack-trace exposure
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StackTraceExposure::Configuration` is needed; otherwise,
 * `StackTraceExposureCustomizations` should be imported instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSteps
private import codeql.ruby.TaintTracking
private import StackTraceExposureCustomizations::StackTraceExposure

/**
 * A taint-tracking configuration for detecting "stack trace exposure" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "StackTraceExposure" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalFlowStep s).step(node1, node2)
  }
}
