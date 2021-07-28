/**
 * Provides a taint tracking configuration for reasoning about
 * command-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

import javascript

module CommandInjection {
  import CommandInjectionCustomizations::CommandInjection
  import IndirectCommandArgument

  /**
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "CommandInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    /**
     * Holds if `sink` is a data flow sink for command-injection vulnerabilities, and
     * the alert should be placed at the node `highlight`.
     */
    predicate isSinkWithHighlight(DataFlow::Node sink, DataFlow::Node highlight) {
      sink instanceof Sink and highlight = sink
      or
      isIndirectCommandArgument(sink, highlight)
    }

    override predicate isSink(DataFlow::Node sink) { isSinkWithHighlight(sink, _) }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }
}
