/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * request forgery, as well as extension points for adding your own.
 */

import semmle.javascript.security.dataflow.RemoteFlowSources

module RequestForgery {
  /**
   * A data flow source for request forgery.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Holds if this source is relevant for server-side request forgery (SSRF).
     *
     * Otherwise, it is considered to be a source for client-side request forgery, which is
     * considered less severe than the server-side variant.
     */
    predicate isServerSide() { any() }
  }

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

  /** A source of server-side remote user input, considered as a flow source for request forgery. */
  private class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource {
    RemoteFlowSourceAsSource() { not this.(ClientSideRemoteFlowSource).getKind().isPathOrUrl() }

    override predicate isServerSide() { not this instanceof ClientSideRemoteFlowSource }
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

  /**
   * Holds if there is a taint step from `pred` to `succ` for request forgery.
   */
  predicate isAdditionalRequestForgeryStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::NewNode url | url = DataFlow::globalVarRef("URL").getAnInstantiation() |
      succ = url and
      pred = url.getArgument(0)
    )
  }
}
