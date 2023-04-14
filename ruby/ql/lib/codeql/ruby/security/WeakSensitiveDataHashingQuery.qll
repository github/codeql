/**
 * Provides a taint-tracking configuration for detecting use of a broken or weak
 * cryptographic hashing algorithm on sensitive data.
 *
 * Note, for performance reasons: only import this file if
 * `WeakSensitiveDataHashing::Configuration` is needed, otherwise
 * `WeakSensitiveDataHashingCustomizations` should be imported instead.
 */

private import ruby
private import codeql.ruby.TaintTracking
private import codeql.ruby.Concepts
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

  /**
   * A taint-tracking configuration for detecting use of a broken or weak
   * cryptographic hashing algorithm on sensitive data.
   */
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isBarrierIn(DataFlow::Node node) { node instanceof Source }
  }

  import TaintTracking::Global<Config>
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
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isBarrierIn(DataFlow::Node node) { node instanceof Source }
  }

  import TaintTracking::Global<Config>
}

/**
 * Provides a path graph for tracking use of a broken or weak cryptographic
 * hashing algorithm on sensitive data.
 */
module WeakSensitiveDataHashing {
  /**
   * A path graph for tracking use of a broken or weak cryptographic
   * hashing algorithm on sensitive data.
   */
  module Config =
    DataFlow::MergePathGraph<NormalHashFunction::PathNode,
      ComputationallyExpensiveHashFunction::PathNode, NormalHashFunction::PathGraph,
      ComputationallyExpensiveHashFunction::PathGraph>;
}
