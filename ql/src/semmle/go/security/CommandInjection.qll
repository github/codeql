/**
 * Provides a taint tracking configuration for reasoning about command
 * injection vulnerabilities
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

import go

module CommandInjection {
  import CommandInjectionCustomizations::CommandInjection

  /**
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "CommandInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuard guard) { guard instanceof SanitizerGuard }
  }
}
