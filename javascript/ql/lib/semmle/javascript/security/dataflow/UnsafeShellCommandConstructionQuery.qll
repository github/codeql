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
class Configuration extends TaintTracking::Configuration {
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
