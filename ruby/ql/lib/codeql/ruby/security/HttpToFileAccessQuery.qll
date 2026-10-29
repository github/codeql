/**
 * Provides a taint tracking configuration for reasoning about writing user-controlled data to files.
 *
 * Note, for performance reasons: only import this file if
 * `HttpToFileAccess::Configuration` is needed, otherwise
 * `HttpToFileAccessCustomizations` should be imported instead.
 */

private import HttpToFileAccessCustomizations::HttpToFileAccess

/**
 * A taint tracking configuration for writing user-controlled data to files.
 */
module HttpToFileAccessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint tracking for writing user-controlled data to files.
 */
module HttpToFileAccessFlow = TaintTracking::Global<HttpToFileAccessConfig>;
