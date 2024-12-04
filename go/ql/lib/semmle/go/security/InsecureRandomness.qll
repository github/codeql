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

  /** Holds if `sink` is a sink for this configuration with kind `kind`. */
  predicate isSinkWithKind(Sink sink, string kind) { kind = sink.getKind() }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { isSinkWithKind(sink, _) }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

    predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
      // Allow flow from tainted indexes to the base expression.
      // Randomly selecting a character/substring/integer from a predefined set
      // with a weak RNG is also a security risk if the result is used in
      // a sensitive function.
      n1.asExpr() = n2.asExpr().(IndexExpr).getIndex() and
      (
        n2.getType() instanceof StringType or
        n2.getType() instanceof IntegerType
      )
    }
  }

  /**
   * Tracks taint flow from randomly generated values which are not
   * cryptographically secure to cryptographic applications.
   */
  module Flow = TaintTracking::Global<Config>;
}
