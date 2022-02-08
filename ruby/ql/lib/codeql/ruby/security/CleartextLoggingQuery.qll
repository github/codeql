/**
 * Provides a taint-tracking configuration for "Clear-text logging of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `CleartextLogging::Configuration` is needed, otherwise
 * `CleartextLoggingCustomizations` should be imported instead.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import CleartextLoggingCustomizations::CleartextLogging
private import CleartextLoggingCustomizations::CleartextLogging as CleartextLogging

/**
 * A taint-tracking configuration for detecting "Clear-text logging of sensitive information".
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CleartextLogging" }

  override predicate isSource(DataFlow::Node source) { source instanceof CleartextLogging::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CleartextLogging::Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof CleartextLogging::Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    CleartextLogging::isAdditionalTaintStep(nodeFrom, nodeTo)
  }
}
