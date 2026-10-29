/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hashing algorithm on sensitive data.
 *
 * Note, for performance reasons: only import this file if
 * `WeakSensitiveDataHashing::Configuration` is needed, otherwise
 * `WeakSensitiveDataHashingCustomizations` should be imported instead.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.security.SensitiveActions

/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hash function on sensitive data, that does NOT require a
 * computationally expensive hash function.
 */
module NormalHashFunction {
  import WeakSensitiveDataHashingCustomizations::NormalHashFunction

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate observeDiffInformedIncrementalMode() { any() }
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
   * Passwords has stricter requirements on the hashing algorithm used (must be
   * computationally expensive to prevent brute-force attacks).
   */
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate observeDiffInformedIncrementalMode() { any() }
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
