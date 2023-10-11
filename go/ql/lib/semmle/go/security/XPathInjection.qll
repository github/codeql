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
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about untrusted user input used in an XPath expression.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "XPathInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /**
   * Tracks taint flow for reasoning about untrusted user input used in an
   * XPath expression.
   */
  module Flow = TaintTracking::Global<Config>;
}
