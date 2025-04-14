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

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() {
      not this.(ClientSideRemoteFlowSource).getKind().isPathOrUrl()
    }

    override predicate isServerSide() { not super.isClientSideSource() }
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
    or
    exists(HtmlSanitizerCall call |
      pred = call.getInput() and
      succ = call
    )
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("request-forgery").asSink() }

    override DataFlow::Node getARequest() { result = this }

    override string getKind() { result = "endpoint" }
  }

  private import Xss as Xss

  /**
   * A call to `encodeURI` or `encodeURIComponent`, viewed as a sanitizer for request forgery.
   * These calls will escape "/" to "%2F", which is not a problem for request forgery.
   * The result from calling `encodeURI` or `encodeURIComponent` is not a valid URL, and only makes sense
   * as a part of a URL.
   */
  class UriEncodingSanitizer extends Sanitizer instanceof Xss::Shared::UriEncodingSanitizer { }
}
