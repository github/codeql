/**
 * Provides classes modeling security-relevant aspects of the `urllib` module, part of
 * the Python standard library.
 *
 * See
 * - https://docs.python.org/2/library/urllib.html
 * - https://docs.python.org/3/library/urllib.html
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.security.dataflow.UrlRedirectCustomizations

/**
 * Provides models for the `urllib` module, part of
 * the Python standard library.
 *
 * See
 * - https://docs.python.org/2/library/urllib.html
 * - https://docs.python.org/3/library/urllib.html
 */
private module Urllib {
  /**
   * Provides models for the `urllib.request` extension library
   *
   * See https://docs.python.org/3.9/library/urllib.request.html
   */
  module Request {
    /**
     * See
     * - https://docs.python.org/3.9/library/urllib.request.html#urllib.request.Request
     */
    private class RequestCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
      RequestCall() {
        this = API::moduleImport("urllib").getMember("request").getMember("Request").getACall()
      }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(0), this.getArgByName("url")] }

      override string getFramework() { result = "urllib.request.Request" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // cannot enable/disable certificate validation on this object, only when used
        // with `urlopen`, which is modeled below
        none()
      }
    }

    /**
     * See
     * - https://docs.python.org/3.9/library/urllib.request.html#urllib.request.urlopen
     */
    private class UrlOpenCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
      UrlOpenCall() {
        this = API::moduleImport("urllib").getMember("request").getMember("urlopen").getACall()
      }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(0), this.getArgByName("url")] }

      override string getFramework() { result = "urllib.request.urlopen" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // will validate certificate by default, see https://github.com/python/cpython/blob/243ed5439c32e8517aa745bc2ca9774d99c99d0f/Lib/http/client.py#L1420-L1421
        // TODO: Handling of insecure SSLContext passed to context argument
        none()
      }
    }
  }

  /**
   * Provides models for the `urllib.parse` extension library.
   */
  module Parse {
    /**
     * A call to `urllib.parse.urlparse`.
     */
    private DataFlow::CallCfgNode getUrlParseCall() {
      result = API::moduleImport("urllib").getMember("parse").getMember("urlparse").getACall()
    }

    /**
     * A read of the `netloc` attribute of a parsed URL as returned by `urllib.parse.urlparse`,
     * which is being checked in a way that is relevant for URL redirection vulnerabilities.
     */
    private predicate netlocCheck(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
      exists(DataFlow::CallCfgNode urlParseCall, DataFlow::AttrRead netlocRead |
        urlParseCall = getUrlParseCall() and
        netlocRead = urlParseCall.getAnAttributeRead("netloc") and
        node = urlParseCall.getArg(0).asCfgNode()
      |
        // either a simple check of the netloc attribute
        g = netlocRead.asCfgNode() and
        branch = false
        or
        // or a comparison (we don't care against what)
        exists(Compare cmp, string op |
          cmp = g.getNode() and
          op = unique(Cmpop opp | opp = cmp.getAnOp()).getSymbol() and
          cmp.getASubExpression() = netlocRead.asExpr()
        |
          op in ["==", "is", "in"] and branch = true
          or
          op in ["!=", "is not", "not in"] and branch = false
        )
      )
    }

    /**
     * A check of `urllib.parse.urlparse().netloc`, considered as a sanitizer-guard for URL redirection.
     */
    private class NetlocCheck extends UrlRedirect::Sanitizer {
      NetlocCheck() { this = DataFlow::BarrierGuard<netlocCheck/3>::getABarrierNode() }

      override predicate sanitizes(UrlRedirect::FlowState state) {
        // `urlparse` does not handle backslashes
        state instanceof UrlRedirect::NoBackslashes
      }
    }
  }
}
