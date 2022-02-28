/**
 * Provides classes modeling security-relevant aspects of the `urllib2` PyPI package.
 * See https://docs.python.org/2/library/urllib2.html
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `urllib2` PyPI package.
 * see https://docs.python.org/2/library/urllib2.html
 */
module Urllib2 {
  /**
   * See
   * - https://docs.python.org/2/library/urllib2.html#urllib2.Request
   */
  private class RequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
    RequestCall() {
      this = API::moduleImport("urllib2").getMember("Request").getACall()
    }

    DataFlow::Node getUrlArg() { result in [this.getArg(0), this.getArgByName("url")] }

    override DataFlow::Node getAUrlPart() { result = this.getUrlArg() }

    override string getFramework() { result = "urllib2.Request" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      none()
    }
  }

  /**
   * See
   * - https://docs.python.org/2/library/urllib2.html#urllib2.urlopen
   */
  private class UrlOpenCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
    UrlOpenCall() { this = API::moduleImport("urllib2").getMember("urlopen").getACall() }

    DataFlow::Node getUrlArg() { result in [this.getArg(0), this.getArgByName("url")] }

    override DataFlow::Node getAUrlPart() { result = this.getUrlArg() }

    override string getFramework() { result = "urllib2.urlopen" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      none()
    }
  }
}
