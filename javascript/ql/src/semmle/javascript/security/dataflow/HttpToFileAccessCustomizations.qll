/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * writing user-controlled data to files, as well as extension points
 * for adding your own.
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

  /** A source of remote user input, considered as a flow source for writing user-controlled data to files. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** A sink that represents file access method (write, append) argument */
  class FileAccessAsSink extends Sink {
    FileAccessAsSink() { exists(FileSystemWriteAccess src | this = src.getADataNode()) }
  }
}
