/**
 * Provides a taint tracking configuration for reasoning about command
 * injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StoredCommand::Configuration` is needed, otherwise
 * `StoredCommandCustomizations` should be imported instead.
 */

import go
import StoredXssCustomizations
import CommandInjectionCustomizations

/**
 * Provides a taint tracking configuration for reasoning about command
 * injection vulnerabilities.
 */
module StoredCommand {
  /**
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "StoredCommand" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof StoredXss::Source and
      // exclude file names, since those are not generally an issue
      not source instanceof StoredXss::FileNameSource
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof CommandInjection::Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof CommandInjection::Sanitizer
    }
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof StoredXss::Source and
      // exclude file names, since those are not generally an issue
      not source instanceof StoredXss::FileNameSource
    }

    predicate isSink(DataFlow::Node sink) { sink instanceof CommandInjection::Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof CommandInjection::Sanitizer }
  }

  /** Tracks taint flow for reasoning about command-injection vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
}
