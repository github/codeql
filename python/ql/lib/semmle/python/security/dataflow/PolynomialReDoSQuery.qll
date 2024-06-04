/**
 * Provides a taint-tracking configuration for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `PolynomialReDoS::Configuration` is needed, otherwise
 * `PolynomialReDoSCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import PolynomialReDoSCustomizations::PolynomialReDoS

/**
 * DEPRECATED: Use `PolynomialReDoSFlow` module instead.
 *
 * A taint-tracking configuration for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PolynomialReDoS" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

private module PolynomialReDoSConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities. */
module PolynomialReDoSFlow = TaintTracking::Global<PolynomialReDoSConfig>;
