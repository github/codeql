/**
 * Provides a taint tracking configuration for reasoning about
 * polynomial regular expression denial-of-service attacks.
 *
 * Note, for performance reasons: only import this file if
 * `PolynomialReDoS::Configuration` is needed, otherwise
 * `PolynomialReDoSCustomizations` should be imported instead.
 */

import javascript
import PolynomialReDoSCustomizations::PolynomialReDoS

/** A taint-tracking configuration for reasoning about polynomial regular expression denial-of-service attacks. */
module PolynomialReDoSConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) { none() }

  int fieldFlowBranchLimit() { result = 1 } // library inputs are too expensive on some projects

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getHighlight().getLocation()
    or
    result = sink.(Sink).getRegExp().getLocation()
  }
}

/** Taint-tracking for reasoning about polynomial regular expression denial-of-service attacks. */
module PolynomialReDoSFlow = TaintTracking::Global<PolynomialReDoSConfig>;

/**
 * DEPRECATED. Use the `PolynomialReDoSFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
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

  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(source, sink) and
    // require that there is a path without unmatched return steps
    DataFlow::hasPathWithoutUnmatchedReturn(source, sink)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    DataFlow::localFieldStep(pred, succ)
  }
}
