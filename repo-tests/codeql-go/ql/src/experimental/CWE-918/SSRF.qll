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
  private import semmle.go.frameworks.Gin
  private import validator
  private import semmle.go.security.UrlConcatenation
  private import semmle.go.dataflow.barrierguardutil.RegexpCheck
  private import semmle.go.dataflow.Properties

  /**
   * A taint-tracking configuration for reasoning about request forgery.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SSRF" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      // propagate to a URL when its host is assigned to
      exists(Write w, Field f, SsaWithFields v | f.hasQualifiedName("net/url", "URL", "Host") |
        w.writesField(v.getAUse(), f, pred) and succ = v.getAUse()
      )
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }

    override predicate isSanitizerOut(DataFlow::Node node) {
      super.isSanitizerOut(node) or
      node instanceof SanitizerEdge
    }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      super.isSanitizerGuard(guard) or guard instanceof SanitizerGuard
    }
  }

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
   * An user controlled input, considered as a flow source for request forgery.
   */
  class UntrustedFlowAsSource extends Source instanceof UntrustedFlowSource { }

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
  class RegexpCheckAsBarrierGuard extends RegexpCheck, SanitizerGuard { }

  /**
   * An equality check comparing a data-flow node against a constant string, considered as
   * a barrier guard for sanitizing untrusted URLs.
   */
  class EqualityAsSanitizerGuard extends SanitizerGuard, DataFlow::EqualityTestNode {
    DataFlow::Node url;

    EqualityAsSanitizerGuard() {
      exists(this.getAnOperand().getStringValue()) and
      url = this.getAnOperand()
    }

    override predicate checks(Expr e, boolean outcome) {
      e = url.asExpr() and outcome = this.getPolarity()
    }
  }

  /**
   * If the tainted variable is a boolean or has numeric type is not possible to exploit a SSRF
   */
  class NumSanitizer extends Sanitizer {
    NumSanitizer() {
      this.getType() instanceof NumericType or
      this.getType() instanceof BoolType
    }
  }

  /**
   * When we receive a body from a request, we can use certain tags on our struct's fields to hint
   * the binding function to run some validations for that field. If these binding functions returns
   * no error, then we consider these fields safe for SSRF.
   */
  class BodySanitizer extends Sanitizer instanceof CheckedAlphanumericStructFieldRead { }

  /**
   * The method Var of package validator is a sanitizer guard only if the check
   * of the error binding exists, and the tag to check is one of "alpha", "alphanum", "alphaunicode", "alphanumunicode", "number", "numeric".
   */
  class ValidatorAsSanitizer extends SanitizerGuard instanceof ValidatorVarCheck {
    override predicate checks(Expr e, boolean branch) { this.checks(e, branch) }
  }
}
