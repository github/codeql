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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "XpathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
