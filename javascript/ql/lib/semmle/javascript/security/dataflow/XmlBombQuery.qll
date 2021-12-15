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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "XmlBomb" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
