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

  // Diff-informed incremental mode is currently disabled for this query due to
  // API limitations. The query exposes sink.getABacktrackingTerm() as an alert
  // location, but there is no way to express that information through
  // getASelectedSinkLocation() because there is no @location in the CodeQL
  // database that corresponds to a term inside a regular expression. As a
  // result, this query could miss alerts in diff-informed incremental mode.
  //
  // To address this problem, we need to have a version of
  // getASelectedSinkLocation() that uses hasLocationInfo() instead of
  // returning Location objects.
  predicate observeDiffInformedIncrementalMode() { none() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getHighlight().getLocation()
    or
    result = sink.(Sink).getABacktrackingTerm().getLocation()
  }
}

/** Global taint-tracking for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities. */
module PolynomialReDoSFlow = TaintTracking::Global<PolynomialReDoSConfig>;
