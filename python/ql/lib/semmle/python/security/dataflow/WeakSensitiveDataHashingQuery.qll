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
   * DEPRECATED: Use `Flow` module instead.
   *
   * A taint-tracking configuration for detecting use of a broken or weak
   * cryptographic hashing algorithm on sensitive data.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
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

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      sensitiveDataExtraStepForCalls(node1, node2)
    }
  }

  /** Global taint-tracking for detecting "use of a broken or weak cryptographic hashing algorithm on sensitive data" vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
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
   * DEPRECATED: Use `Flow` module instead.
   *
   * A taint-tracking configuration for detecting use of a broken or weak
   * cryptographic hashing algorithm on passwords.
   *
   * Passwords has stricter requirements on the hashing algorithm used (must be
   * computationally expensive to prevent brute-force attacks).
   */
  deprecated class Configuration extends TaintTracking::Configuration {
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

  /**
   * Passwords has stricter requirements on the hashing algorithm used (must be
   * computationally expensive to prevent brute-force attacks).
   */
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      sensitiveDataExtraStepForCalls(node1, node2)
    }
  }

  /** Global taint-tracking for detecting "use of a broken or weak cryptographic hashing algorithm on passwords" vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;
}

/**
 * Global taint-tracking for detecting both variants of "use of a broken or weak
 * cryptographic hashing algorithm on sensitive data" vulnerabilities.
 *
 * See convenience predicates `normalHashFunctionFlowPath` and
 * `computationallyExpensiveHashFunctionFlowPath`.
 */
module WeakSensitiveDataHashingFlow =
  DataFlow::MergePathGraph<NormalHashFunction::Flow::PathNode,
    ComputationallyExpensiveHashFunction::Flow::PathNode, NormalHashFunction::Flow::PathGraph,
    ComputationallyExpensiveHashFunction::Flow::PathGraph>;

/** Holds if data can flow from `source` to `sink` with `NormalHashFunction::Flow`. */
predicate normalHashFunctionFlowPath(
  WeakSensitiveDataHashingFlow::PathNode source, WeakSensitiveDataHashingFlow::PathNode sink
) {
  NormalHashFunction::Flow::flowPath(source.asPathNode1(), sink.asPathNode1())
}

/** Holds if data can flow from `source` to `sink` with `ComputationallyExpensiveHashFunction::Flow`. */
predicate computationallyExpensiveHashFunctionFlowPath(
  WeakSensitiveDataHashingFlow::PathNode source, WeakSensitiveDataHashingFlow::PathNode sink
) {
  ComputationallyExpensiveHashFunction::Flow::flowPath(source.asPathNode2(), sink.asPathNode2())
}
