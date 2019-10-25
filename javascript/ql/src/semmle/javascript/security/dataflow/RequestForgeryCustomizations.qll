/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * request forgery, as well as extension points for adding your own.
 */

import semmle.javascript.security.dataflow.RemoteFlowSources

module RequestForgery {
  /**
   * A data flow source for request forgery.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for request forgery.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a request that uses this sink.
     */
    abstract DataFlow::Node getARequest();

    /**
     * Gets the kind of this sink.
     */
    abstract string getKind();
  }

  /**
   * A sanitizer for request forgery.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for request forgery. */
  private class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The URL of a URL request, viewed as a sink for request forgery.
   */
  private class ClientRequestUrlAsSink extends Sink {
    ClientRequest request;
    string kind;

    ClientRequestUrlAsSink() {
      this = request.getUrl() and kind = "URL"
      or
      this = request.getHost() and kind = "host"
    }

    override DataFlow::Node getARequest() { result = request }

    override string getKind() { result = kind }
  }
}
