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
