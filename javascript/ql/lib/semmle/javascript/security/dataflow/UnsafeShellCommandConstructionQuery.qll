/**
 * Provides a taint tracking configuration for reasoning about shell command
 * constructed from library input vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeShellCommandConstruction::Configuration` is needed, otherwise
 * `UnsafeShellCommandConstructionCustomizations` should be imported instead.
 */

import javascript
import UnsafeShellCommandConstructionCustomizations::UnsafeShellCommandConstruction

/**
 * A taint-tracking configuration for reasoning about shell command constructed from library input vulnerabilities.
 */
module UnsafeShellCommandConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode() or
    node = TaintTracking::AdHocWhitelistCheckSanitizer::getABarrierNode()
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getAlertLocation().getLocation()
    or
    result = sink.(Sink).getCommandExecution().getLocation()
  }
}

/**
 * Taint-tracking for reasoning about shell command constructed from library input vulnerabilities.
 */
module UnsafeShellCommandConstructionFlow =
  TaintTracking::Global<UnsafeShellCommandConstructionConfig>;

/**
 * DEPRECATED. Use the `UnsafeShellCommandConstructionFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeShellCommandConstruction" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof PathExistsSanitizerGuard or
    guard instanceof TaintTracking::AdHocWhitelistCheckSanitizer or
    guard instanceof NumberGuard or
    guard instanceof TypeOfSanitizer
  }

  // override to require that there is a path without unmatched return steps
  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(source, sink) and
    DataFlow::hasPathWithoutUnmatchedReturn(source, sink)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    DataFlow::localFieldStep(pred, succ)
  }
}
