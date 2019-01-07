/**
 * Provides a taint tracking configuration for reasoning about writing user-controlled data to files.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module HttpToFileAccess {
  /**
   * A data flow source for writing user-controlled data to files.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for writing user-controlled data to files.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for writing user-controlled data to files.
   */
  abstract class Sanitizer extends DataFlow::Node { }

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

  /** A source of remote user input, considered as a flow source for writing user-controlled data to files. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** A sink that represents file access method (write, append) argument */
  class FileAccessAsSink extends Sink {
    FileAccessAsSink() { exists(FileSystemWriteAccess src | this = src.getADataNode()) }
  }
}
