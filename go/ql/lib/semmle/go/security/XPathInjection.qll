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
