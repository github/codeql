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
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "NormalHashFunction" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
    }

    override predicate isSanitizerIn(DataFlow::Node node) { node instanceof Source }
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

    override predicate isSanitizerIn(DataFlow::Node node) { node instanceof Source }
  }
}
