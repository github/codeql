/**
 * Provides a taint-tracking configuration for reasoning about request forgery
 * (SSRF) vulnerabilities.
 */

import go

/**
 * Provides a taint-tracking configuration for reasoning about request forgery
 * (SSRF) vulnerabilities.
 */
module ServerSideRequestForgery {
  private import validator
  private import semmle.go.security.UrlConcatenation
  private import semmle.go.dataflow.barrierguardutil.RegexpCheck
  private import semmle.go.dataflow.Properties

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      // propagate to a URL when its host is assigned to
      exists(Write w, Field f, SsaWithFields v | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(v.getAUse(), f, node1) and node2 = v.getAUse()
      )
    }

    predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

    predicate isBarrierOut(DataFlow::Node node) { node instanceof SanitizerEdge }
  }

  /** Tracks taint flow for reasoning about request forgery vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;

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
   * DEPRECATED: Use `ActiveThreatModelSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /**
   * An user controlled input, considered as a flow source for request forgery.
   */
  private class ThreatModelFlowAsSource extends Source instanceof ActiveThreatModelSource { }

  /**
   * The URL of an HTTP request, viewed as a sink for request forgery.
   */
  private class ClientRequestUrlAsSink extends Sink {
    Http::ClientRequest request;

    ClientRequestUrlAsSink() { this = request.getUrl() }

    override DataFlow::Node getARequest() { result = request }

    override string getKind() { result = "URL" }
  }

  /**
   * The URL of a WebSocket request, viewed as a sink for request forgery.
   */
  class WebSocketCallAsSink extends Sink {
    WebSocketRequestCall request;

    WebSocketCallAsSink() { this = request.getRequestUrl() }

    override DataFlow::Node getARequest() { result = request }

    override string getKind() { result = "WebSocket URL" }
  }

  /**
   * Result value of prepending a string that prevents any value from controlling the
   * host of a URL.
   */
  private class PathSanitizer extends SanitizerEdge {
    PathSanitizer() { sanitizingPrefixEdge(this, _) }
  }

  /**
   * A call to a regexp match function, considered as a barrier guard for sanitizing untrusted URLs.
   *
   * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
   */
  class RegexpCheckAsBarrierGuard extends RegexpCheckBarrier, Sanitizer { }

  private predicate equalityAsSanitizerGuard(DataFlow::Node g, Expr e, boolean outcome) {
    exists(DataFlow::Node url, DataFlow::EqualityTestNode eq |
      g = eq and
      exists(eq.getAnOperand().getStringValue()) and
      url = eq.getAnOperand() and
      e = url.asExpr() and
      outcome = eq.getPolarity()
    )
  }

  /**
   * An equality check comparing a data-flow node against a constant string, considered as
   * a barrier guard for sanitizing untrusted URLs.
   */
  class EqualityAsSanitizerGuard extends Sanitizer {
    EqualityAsSanitizerGuard() {
      this = DataFlow::BarrierGuard<equalityAsSanitizerGuard/3>::getABarrierNode()
    }
  }

  /**
   * A value which has boolean or numeric type, considered as a sanitizer for SSRF.
   */
  class NumSanitizer extends Sanitizer {
    NumSanitizer() {
      this.getType() instanceof NumericType or
      this.getType() instanceof BoolType
    }
  }

  /**
   * A body received from a request, where certain tags on our struct's fields have been used to hint
   * to the binding function to run some validations for that field. If these binding functions returns
   * no error, then we consider these fields safe for SSRF.
   */
  class BodySanitizer extends Sanitizer instanceof CheckedAlphanumericStructFieldRead { }

  /**
   * The method Var of package validator is a sanitizer guard only if the check
   * of the error binding exists, and the tag to check is one of "alpha", "alphanum", "alphaunicode", "alphanumunicode", "number", "numeric".
   */
  class ValidatorAsSanitizer extends Sanitizer, ValidatorVarCheckBarrier { }
}
