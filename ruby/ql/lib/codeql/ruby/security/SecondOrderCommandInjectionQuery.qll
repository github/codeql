/**
 * Provides a taint tracking configuration for reasoning about
 * second order command-injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SecondOrderCommandInjection::Configuration` is needed, otherwise
 * `SecondOrderCommandInjectionCustomizations` should be imported instead.
 */

import ruby
import SecondOrderCommandInjectionCustomizations::SecondOrderCommandInjection
import codeql.ruby.TaintTracking

/**
 * A taint-tracking configuration for reasoning about second order command-injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SecondOrderCommandInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
