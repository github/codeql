/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hashing algorithm on sensitive data.
 *
 * Note, for performance reasons: only import this file if
 * `WeakSensitiveDataHashing::Configuration` is needed, otherwise
 * `WeakSensitiveDataHashingCustomizations` should be imported instead.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.dataflow.new.SensitiveDataSources

/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hash function on sensitive data, that does NOT require a
 * computationally expensive hash function.
 */
module NormalHashFunction {
  import WeakSensitiveDataHashingCustomizations::NormalHashFunction

  /**
   * A taint-tracking configuration for detecting use of a broken or weak
   * cryptographic hashing algorithm on sensitive data.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "NormalHashFunction" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      sensitiveDataExtraStepForCalls(node1, node2)
    }
  }
}

/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hashing algorithm on passwords.
 *
 * Passwords has stricter requirements on the hashing algorithm used (must be
 * computationally expensive to prevent brute-force attacks).
 */
module ComputationallyExpensiveHashFunction {
  import WeakSensitiveDataHashingCustomizations::ComputationallyExpensiveHashFunction

  /**
   * A taint-tracking configuration for detecting use of a broken or weak
   * cryptographic hashing algorithm on passwords.
   *
   * Passwords has stricter requirements on the hashing algorithm used (must be
   * computationally expensive to prevent brute-force attacks).
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ComputationallyExpensiveHashFunction" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
    }

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      sensitiveDataExtraStepForCalls(node1, node2)
    }
  }
}
