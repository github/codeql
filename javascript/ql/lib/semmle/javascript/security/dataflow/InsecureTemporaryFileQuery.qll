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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "InsecureTemporaryFile" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
