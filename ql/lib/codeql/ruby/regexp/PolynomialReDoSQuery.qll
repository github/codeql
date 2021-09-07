/**
 * Provides a taint tracking configuration for reasoning about polynomial
 * regular expression denial-of-service attacks.
 *
 * Note, for performance reasons: only import this file if `Configuration` is
 * needed. Otherwise, `PolynomialReDoSCustomizations` should be imported
 * instead.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting polynomial regular
 * expression denial of service vulnerabilities.
 */
module PolynomialReDoS {
  import PolynomialReDoSCustomizations::PolynomialReDoS

  /**
   * A taint-tracking configuration for detecting polynomial regular expression
   * denial of service vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "PolynomialReDoS" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard node) {
      node instanceof SanitizerGuard
    }
  }
}
