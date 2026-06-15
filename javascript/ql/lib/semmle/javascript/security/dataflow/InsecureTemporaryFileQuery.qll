/**
 * Provides a taint tracking configuration for reasoning about insecure temporary
 * file creation.
 *
 * Note, for performance reasons: only import this file if
 * `InsecureTemporaryFile::Configuration` is needed, otherwise
 * `InsecureTemporaryFileCustomizations` should be imported instead.
 */

import javascript
import InsecureTemporaryFileCustomizations::InsecureTemporaryFile

/**
 * A taint-tracking configuration for reasoning about insecure temporary file creation.
 */
module InsecureTemporaryFileConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about insecure temporary file creation.
 */
module InsecureTemporaryFileFlow = TaintTracking::Global<InsecureTemporaryFileConfig>;

/**
 * DEPRECATED. Use the `InsecureTemporaryFileFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "InsecureTemporaryFile" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
