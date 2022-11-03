/**
 * Provides default sources, sinks and sanitizers for reasoning about
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
  deprecated class RemoteFlowSourceAsSource extends DataFlow::Node {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An access to a user-controlled HTTP request input, considered as a flow source for writing user-controlled data to files
   */
  private class RequestInputAccessAsSource extends Source {
    RequestInputAccessAsSource() { this instanceof HTTP::RequestInputAccess }
  }

  /** A response from a server, considered as a flow source for writing user-controlled data to files. */
  private class ServerResponseAsSource extends Source {
    ServerResponseAsSource() { this = any(ClientRequest r).getAResponseDataNode() }
  }

  /** A sink that represents file access method (write, append) argument */
  class FileAccessAsSink extends Sink {
    FileAccessAsSink() { exists(FileSystemWriteAccess src | this = src.getADataNode()) }
  }
}
