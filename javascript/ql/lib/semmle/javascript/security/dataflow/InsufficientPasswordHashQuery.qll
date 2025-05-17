/**
 * Provides a taint tracking configuration for reasoning about
 * password hashing with insufficient computational effort.
 *
 * Note, for performance reasons: only import this file if
 * `InsufficientPasswordHash::Configuration` is needed, otherwise
 * `InsufficientPasswordHashCustomizations` should be imported instead.
 */

import javascript
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
module InsufficientPasswordHashConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking for password hashing with insufficient computational effort.
 */
module InsufficientPasswordHashFlow = TaintTracking::Global<InsufficientPasswordHashConfig>;
