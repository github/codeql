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
module BrokenCryptoAlgorithmConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getInitialization().getLocation()
  }
}

/**
 * Taint tracking flow for sensitive information in broken or weak cryptographic algorithms.
 */
module BrokenCryptoAlgorithmFlow = TaintTracking::Global<BrokenCryptoAlgorithmConfig>;
