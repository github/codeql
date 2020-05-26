/**
 * Provides a taint tracking configuration for reasoning about shell command
 * constructed from library input vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeShellCommandConstruction::Configuration` is needed, otherwise
 * `UnsafeShellCommandConstructionCustomizations` should be imported instead.
 */

import javascript

/**
 * Classes and predicates for the shell command constructed from library input query.
 */
module UnsafeShellCommandConstruction {
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
      guard instanceof TaintTracking::AdHocWhitelistCheckSanitizer
    }
  }
}
