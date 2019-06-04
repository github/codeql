/**
 * Provides a taint-tracking configuration for reasoning about request forgery.
 */

import semmle.javascript.security.dataflow.RemoteFlowSources
import UrlConcatenation

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

  /**
   * A taint tracking configuration for request forgery.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "RequestForgery" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerEdge(DataFlow::Node source, DataFlow::Node sink) {
      sanitizingPrefixEdge(source, sink)
    }
  }

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
