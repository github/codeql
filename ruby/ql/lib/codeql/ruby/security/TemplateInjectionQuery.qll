/**
 * Provides default sources, sinks and sanitizers for detecting
 * Server Side Template Injections, as well as extension points for adding your own
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import TemplateInjectionCustomizations::TemplateInjection

/**
 * A taint-tracking configuration for detecting Server Side Template Injections vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "TemplateInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node source) { source instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
