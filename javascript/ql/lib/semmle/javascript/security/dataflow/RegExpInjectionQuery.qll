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
