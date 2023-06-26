/**
 * Provides default sources, sinks and sanitizers for detecting SQL injection
 * vulnerabilities, as well as extension points for adding your own.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import SqlInjectionCustomizations::SqlInjection

/**
 * A taint-tracking configuration for detecting SQL injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SqlInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
