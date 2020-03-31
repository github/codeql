/**
 * Provides a taint tracking configuration for reasoning about
 * polynomial regular expression denial-of-service attacks.
 *
 * Note, for performance reasons: only import this file if
 * `PolynomialReDoS::Configuration` is needed, otherwise
 * `PolynomialReDoSCustomizations` should be imported instead.
 */

import javascript

module PolynomialReDoS {
  import PolynomialReDoSCustomizations::PolynomialReDoS

  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "PolynomialReDoS" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
      super.isSanitizerGuard(node) or
      node instanceof LengthGuard
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}
