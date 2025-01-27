/**
 * Provides a taint tracking configuration for reasoning about XML
 * External Entity (XXE) vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `Xxe::Configuration` is needed, otherwise `XxeCustomizations`
 * should be imported instead.
 */

import javascript
import XxeCustomizations::Xxe

/**
 * A taint-tracking configuration for reasoning about XXE vulnerabilities.
 */
module XxeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about XXE vulnerabilities.
 */
module XxeFlow = TaintTracking::Global<XxeConfig>;
