/**
 * Provides a taint-tracking configuration for reasoning about improper code
 * sanitization.
 *
 * Note, for performance reasons: only import this file if
 * `ImproperCodeSanitization::Configuration` is needed, otherwise
 * `ImproperCodeSanitizationCustomizations` should be imported instead.
 */

import javascript
import ImproperCodeSanitizationCustomizations::ImproperCodeSanitization

/**
 * A taint-tracking configuration for reasoning about improper code sanitization vulnerabilities.
 */
module ImproperCodeSanitizationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about improper code sanitization vulnerabilities.
 */
module ImproperCodeSanitizationFlow = TaintTracking::Global<ImproperCodeSanitizationConfig>;

/**
 * DEPRECATED. Use the `ImproperCodeSanitizationFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ImproperCodeSanitization" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof Sanitizer }
}
