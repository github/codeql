/**
 * Provides a taint tracking configuration for reasoning about writing user-controlled data to files.
 *
 * Note, for performance reasons: only import this file if
 * `HttpToFileAccess::Configuration` is needed, otherwise
 * `HttpToFileAccessCustomizations` should be imported instead.
 */

import javascript

module HttpToFileAccess {
  import HttpToFileAccessCustomizations::HttpToFileAccess

  /**
   * A taint tracking configuration for writing user-controlled data to files.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "HttpToFileAccess" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}
