/**
 * Provides a taint-tracking configuration for reasoning about improper code
 * sanitization.
 *
 * Note, for performance reasons: only import this file if
 * `ImproperCodeSanitization::Configuration` is needed, otherwise
 * `ImproperCodeSanitizationCustomizations` should be imported instead.
 */

import javascript

/**
 * Classes and predicates for reasoning about improper code sanitization.
 */
module ImproperCodeSanitization {
  import ImproperCodeSanitizationCustomizations::ImproperCodeSanitization

  /**
   * A taint-tracking configuration for reasoning about improper code sanitization vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ImproperCodeSanitization" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof Sanitizer }
  }
}
