/** 
 * Provides taint tracking configuration for reasoning about files created from untrusted http downloads.  
 */
import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module HttpToFileAccessFlow {
  /**
   * A data flow source from untrusted http request to file access taint tracking configuration.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for untrusted http request to file access taint tracking configuration.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for untrusted http request to file access taint tracking configuration.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A taint-tracking configuration for reasoning about file access from untrusted http response body.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "HttpToFileAccessFlow" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
  
  /** A source of remote data, considered as a flow source for untrusted http data to file system access. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }
  
  /** A sink that represents file access method (write, append) argument */
  class FileAccessAsSink extends Sink {
    FileAccessAsSink () {
      exists(FileSystemWriteAccess src |
        this = src.getDataNode()
      )
    }
  }
}