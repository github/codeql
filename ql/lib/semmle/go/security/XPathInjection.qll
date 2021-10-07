/**
 * Provides a taint tracking configuration for reasoning about untrusted user input used in an XPath expression.
 *
 * Note: for performance reasons, only import this file if `XPathInjection::Configuration` is needed,
 * otherwise `XPathInjectionCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint tracking configuration for reasoning about untrusted user input used in an XPath expression.
 */
module XPathInjection {
  import XPathInjectionCustomizations::XPathInjection

  /**
   * A taint-tracking configuration for reasoning about untrusted user input used in an XPath expression.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "XPathInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
