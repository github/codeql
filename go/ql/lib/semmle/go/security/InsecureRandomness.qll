/**
 * Provides a taint-tracking configuration for reasoning about random values that are
 * not cryptographically secure.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureRandomness::Configuration` is needed, otherwise
 * `InsecureRandomnessCustomizations` should be imported instead.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about random values that are
 * not cryptographically secure.
 */
module InsecureRandomness {
  import InsecureRandomnessCustomizations::InsecureRandomness

  /**
   * A taint-tracking configuration for reasoning about random values that are
   * not cryptographically secure.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsecureRandomness" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { this.isSinkWithKind(sink, _) }

    /** Holds if `sink` is a sink for this configuration with kind `kind`. */
    predicate isSinkWithKind(Sink sink, string kind) { kind = sink.getKind() }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }
}
