/**
 * Provides a taint-tracking configuration for reasoning about
 * untrusted user input used to construct regular expressions.
 *
 * Note, for performance reasons: only import this file if
 * `RegExpInjection::Configuration` is needed, otherwise
 * `RegExpInjectionCustomizations` should be imported instead.
 */

import javascript
import RegExpInjectionCustomizations::RegExpInjection

/**
 * A taint-tracking configuration for untrusted user input used to construct regular expressions.
 */
module RegExpInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for untrusted user input used to construct regular expressions.
 */
module RegExpInjectionFlow = TaintTracking::Global<RegExpInjectionConfig>;

/**
 * DEPRECATED. Use the `RegExpInjectionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RegExpInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
