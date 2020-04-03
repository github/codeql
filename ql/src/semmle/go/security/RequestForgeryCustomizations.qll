/**
 * Provides classes and predicates used by the request forgery query.
 */

import go
import UrlConcatenation
import SafeUrlFlowCustomizations

/** Provides classes and predicates for the request forgery query. */
module RequestForgery {
  /** A data flow source for request forgery vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for request forgery vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /** Gets a request that uses this sink. */
    abstract DataFlow::Node getARequest();

    /**
     * Gets the name of a part of the request that may be tainted by this sink,
     * such as the URL or the host.
     */
    abstract string getKind();
  }

  /** A sanitizer for request forgery vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** An outgoing sanitizer edge for request forgery vulnerabilities. */
  abstract class SanitizerEdge extends DataFlow::Node { }

  /**
   * A sanitizer guard for request forgery vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A third-party controllable input, considered as a flow source for request forgery.
   */
  class UntrustedFlowAsSource extends Source, UntrustedFlowSource { }

  /**
   * The URL of an HTTP request, viewed as a sink for request forgery.
   */
  private class ClientRequestUrlAsSink extends Sink {
    HTTP::ClientRequest request;

    ClientRequestUrlAsSink() { this = request.getUrl() }

    override DataFlow::Node getARequest() { result = request }

    override string getKind() { result = "URL" }
  }

  /**
   * A value that is the result of prepending a string that prevents any value from controlling the
   * host of a URL.
   */
  private class HostnameSanitizer extends SanitizerEdge {
    HostnameSanitizer() { hostnameSanitizingPrefixEdge(this, _) }
  }
}

/** A sink for request forgery, considered as a sink for safe URL flow. */
private class SafeUrlSink extends SafeUrlFlow::Sink {
  SafeUrlSink() { this instanceof RequestForgery::Sink }
}

/**
 * A read of a field considered unsafe for request forgery, considered as a sanitizer for a safe
 * URL.
 */
private class UnsafeFieldReadSanitizer extends SafeUrlFlow::SanitizerEdge {
  UnsafeFieldReadSanitizer() {
    exists(DataFlow::FieldReadNode frn, string name |
      (name = "RawQuery" or name = "Fragment" or name = "User") and
      frn.getField().hasQualifiedName("net/url", "URL")
    |
      this = frn.getBase()
    )
  }
}
