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
}
