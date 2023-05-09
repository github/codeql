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
  module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

  private module ConfigurationImpl implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    additional deprecated predicate isSanitizerGuard(DataFlow::BarrierGuard node) {
      node instanceof SanitizerGuard
    }
  }
}
