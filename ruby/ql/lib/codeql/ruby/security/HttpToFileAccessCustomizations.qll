/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * writing user-controlled data to files, as well as extension points
 * for adding your own.
 */

import ruby
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.Concepts

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * writing user-controlled data to files, as well as extension points
 * for adding your own.
 */
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
   * An access to a user-controlled HTTP request input, considered as a flow source for writing user-controlled data to files
   */
  private class RequestInputAccessAsSource extends Source instanceof HTTP::Server::RequestInputAccess {
  }

  /** A response from an outgoing HTTP request, considered as a flow source for writing user-controlled data to files. */
  private class HttpResponseAsSource extends Source {
    HttpResponseAsSource() { this = any(HTTP::Client::Request r).getResponseBody() }
  }

  /** A sink that represents file access method (write, append) argument */
  class FileAccessAsSink extends Sink {
    FileAccessAsSink() { exists(FileSystemWriteAccess src | this = src.getADataNode()) }
  }
}
