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
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsecureRandomness" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
