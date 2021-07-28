/**
 * Provides a taint tracking configuration for reasoning about
 * password hashing with insufficient computational effort.
 *
 * Note, for performance reasons: only import this file if
 * `InsufficientPasswordHash::Configuration` is needed, otherwise
 * `InsufficientPasswordHashCustomizations` should be imported instead.
 */

import javascript

module InsufficientPasswordHash {
  import InsufficientPasswordHashCustomizations::InsufficientPasswordHash

  /**
   * A taint tracking configuration for password hashing with insufficient computational effort.
   *
   * This configuration identifies flows from `Source`s, which are sources of
   * password data, to `Sink`s, which is an abstract class representing all
   * the places password data may be hashed with insufficient computational effort. Additional sources or sinks can be
   * added either by extending the relevant class, or by subclassing this configuration itself,
   * and amending the sources and sinks.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "InsufficientPasswordHash" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}
