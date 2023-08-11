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
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-tracking configuration for reasoning about random values that are
   * not cryptographically secure.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsecureRandomness" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { this.isSinkWithKind(sink, _) }

    /** Holds if `sink` is a sink for this configuration with kind `kind`. */
    predicate isSinkWithKind(Sink sink, string kind) { kind = sink.getKind() }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Holds if `sink` is a sink for this configuration with kind `kind`. */
  predicate isSinkWithKind(Sink sink, string kind) { kind = sink.getKind() }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { isSinkWithKind(sink, _) }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /**
   * Tracks taint flow from randomly generated values which are not
   * cryptographically secure to cryptographic applications.
   */
  module Flow = TaintTracking::Global<Config>;
}
