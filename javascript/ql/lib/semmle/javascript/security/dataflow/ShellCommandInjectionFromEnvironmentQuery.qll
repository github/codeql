/**
 * Provides a taint tracking configuration for reasoning about
 * command-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `ShellCommandInjectionFromEnvironment::Configuration` is needed, otherwise
 * `ShellCommandInjectionFromEnvironmentCustomizations` should be imported instead.
 */

import javascript
import ShellCommandInjectionFromEnvironmentCustomizations::ShellCommandInjectionFromEnvironment
import IndirectCommandArgument

/**
 * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ShellCommandInjectionFromEnvironment" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  /** Holds if `sink` is a command-injection sink with `highlight` as the corresponding alert location. */
  predicate isSinkWithHighlight(DataFlow::Node sink, DataFlow::Node highlight) {
    sink instanceof Sink and highlight = sink
    or
    isIndirectCommandArgument(sink, highlight)
  }

  override predicate isSink(DataFlow::Node sink) { isSinkWithHighlight(sink, _) }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
