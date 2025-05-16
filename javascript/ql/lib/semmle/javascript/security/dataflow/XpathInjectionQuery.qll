/**
 * Provides a taint-tracking configuration for reasoning about
 * untrusted user input used in XPath expression.
 *
 * Note, for performance reasons: only import this file if
 * `XpathInjection::Configuration` is needed, otherwise
 * `XpathInjectionCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.dataflow.DOM
import XpathInjectionCustomizations::XpathInjection

/**
 * A taint-tracking configuration for untrusted user input used in XPath expression.
 */
module XpathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for untrusted user input used in XPath expression.
 */
module XpathInjectionFlow = TaintTracking::Global<XpathInjectionConfig>;
