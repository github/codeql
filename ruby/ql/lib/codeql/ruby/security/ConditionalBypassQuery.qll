/**
 * Provides a taint tracking configuration for reasoning about bypass of sensitive action guards.
 *
 * Note, for performance reasons: only import this file if
 * `ConditionalBypass::Configuration` is needed, otherwise
 * `ConditionalBypassCustomizations` should be imported instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.security.SensitiveActions
import ConditionalBypassCustomizations::ConditionalBypass

/**
 * A taint tracking configuration for bypass of sensitive action guards.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ConditionalBypass" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
