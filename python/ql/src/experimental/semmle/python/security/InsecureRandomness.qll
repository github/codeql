/**
 * Provides a taint tracking configuration for reasoning about random
 * values that are not cryptographically secure.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureRandomness::Configuration` is needed, otherwise
 * `InsecureRandomnessCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * A taint tracking configuration for random values that are not cryptographically secure.
 */
module InsecureRandomness {
  import InsecureRandomnessCustomizations::InsecureRandomness

  /**
   * A taint-tracking configuration for reasoning about random values that are
   * not cryptographically secure.
   */
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /** Global taint-tracking for detecting "random values that are not cryptographically secure" vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
}
