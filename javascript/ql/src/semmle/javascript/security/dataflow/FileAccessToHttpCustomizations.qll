/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * file data in outbound network requests, as well as extension points
 * for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module FileAccessToHttp {
  /**
   * A data flow source for file data in outbound network requests.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for file data in outbound network requests.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for file data in outbound network requests.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A file access parameter, considered as a flow source for file data in outbound network requests.
   */
  private class FileAccessArgumentAsSource extends Source {
    FileAccessArgumentAsSource() {
      exists(FileSystemReadAccess src | this = src.getADataNode().getALocalSource())
    }
  }

  /**
   * The URL or data of a client request, considered as a flow source for file data in outbound network requests.
   */
  private class ClientRequestUrlOrDataAsSink extends Sink {
    ClientRequestUrlOrDataAsSink() {
      exists(ClientRequest req |
        this = req.getUrl() or
        this = req.getADataNode()
      )
    }
  }
}
