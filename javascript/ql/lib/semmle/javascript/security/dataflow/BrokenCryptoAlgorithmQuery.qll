/**
 * Provides a taint tracking configuration for reasoning about
 * sensitive information in broken or weak cryptographic algorithms.
 *
 * Note, for performance reasons: only import this file if
 * `BrokenCryptoAlgorithm::Configuration` is needed, otherwise
 * `BrokenCryptoAlgorithmCustomizations` should be imported instead.
 */

import javascript
import BrokenCryptoAlgorithmCustomizations::BrokenCryptoAlgorithm

/**
 * A taint tracking configuration for sensitive information in broken or weak cryptographic algorithms.
 *
 * This configuration identifies flows from `Source`s, which are sources of
 * sensitive data, to `Sink`s, which is an abstract class representing all
 * the places sensitive data may used in broken or weak cryptographic algorithms. Additional sources or sinks can be
 * added either by extending the relevant class, or by subclassing this configuration itself,
 * and amending the sources and sinks.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "BrokenCryptoAlgorithm" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
