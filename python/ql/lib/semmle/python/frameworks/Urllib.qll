/**
 * Provides classes modeling security-relevant aspects of the `urllib` PyPI package.
 * See https://docs.python.org/3.9/library/urllib.html
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `Urllib` PyPI package.
 * see https://docs.python.org/3.9/library/urllib.html
 */
module Urllib {
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
    private class RequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      RequestCall() {
        this = API::moduleImport("urllib").getMember("request").getMember("Request").getACall()
      }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(0), this.getArgByName("url")] }

      override string getFramework() { result = "urllib.request.Request" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Look into disabling certificate validation
        none()
      }
    }

    /**
     * See
     * - https://docs.python.org/3.9/library/urllib.request.html#urllib.request.urlopen
     */
    private class UrlOpenCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      UrlOpenCall() {
        this = API::moduleImport("urllib").getMember("request").getMember("urlopen").getACall()
      }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(0), this.getArgByName("url")] }

      override string getFramework() { result = "urllib.request.urlopen" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Look into disabling certificate validation
        none()
      }
    }
  }
}
