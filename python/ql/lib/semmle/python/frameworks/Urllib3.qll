/**
 * Provides classes modeling security-relevant aspects of the `urllib3` PyPI package.
 * See https://urllib3.readthedocs.io/en/stable/reference/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `Urllib3` PyPI package.
 * see https://urllib3.readthedocs.io/en/stable/reference/
 */
module Urllib3 {
  /**
   * Provides models for the `urllib3.PoolManager` class
   *
   * See https://urllib3.readthedocs.io/en/stable/reference/urllib3.poolmanager.html.
   */
  module PoolManager {
    /** Gets a reference to the `urllib3.PoolManager` class. */
    private API::Node classRef() { result = API::moduleImport("urllib3").getMember("PoolManager") }

    /** Gets a reference to an instance of `urllib3.PoolManager`. */
    private API::Node instance() { result = classRef().getReturn() }

    private class RequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      RequestCall() {
        this =
          instance().getMember(["request", "request_encode_url", "request_encode_body"]).getACall()
      }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(1), this.getArgByName("url")] }

      override string getFramework() { result = "urllib3.PoolManager" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Look into disabling certificate validation
        none()
      }
    }

    private class UrlOpenCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      UrlOpenCall() { this = instance().getMember("urlopen").getACall() }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(1), this.getArgByName("url")] }

      override string getFramework() { result = "urllib3.PoolManager" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Look into disabling certificate validation
        none()
      }
    }
  }
}
