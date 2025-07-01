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

private module PolynomialReDoSConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getHighlight().getLocation()
  }

  Location getASelectedSinkLocationApprox(DataFlow::Node sink) {
    result = sink.(Sink).getABacktrackingTerm().getLocation()
  }
}

/** Global taint-tracking for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities. */
module PolynomialReDoSFlow = TaintTracking::Global<PolynomialReDoSConfig>;
