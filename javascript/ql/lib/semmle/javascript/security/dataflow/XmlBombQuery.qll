/**
 * Provides a taint tracking configuration for reasoning about
 * XML-bomb vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `XmlBomb::Configuration` is needed, otherwise
 * `XmlBombCustomizations` should be imported instead.
 */

import javascript
import XmlBombCustomizations::XmlBomb

/**
 * A taint-tracking configuration for reasoning about XML-bomb vulnerabilities.
 */
module XmlBombConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about XML-bomb vulnerabilities.
 */
module XmlBombFlow = TaintTracking::Global<XmlBombConfig>;
