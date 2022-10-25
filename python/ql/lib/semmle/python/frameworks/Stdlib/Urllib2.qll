/**
 * Provides classes modeling security-relevant aspects of the `urllib2` module, part of
 * the Python 2 standard library.
 *
 * See https://docs.python.org/2/library/urllib2.html
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `urllib2` module, part of
 * the Python 2 standard library.
 *
 * See https://docs.python.org/2/library/urllib2.html
 */
private module Urllib2 {
  /**
   * See
   * - https://docs.python.org/2/library/urllib2.html#urllib2.Request
   */
  private class RequestCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
    RequestCall() { this = API::moduleImport("urllib2").getMember("Request").getACall() }

    override DataFlow::Node getAUrlPart() { result in [this.getArg(0), this.getArgByName("url")] }

    override string getFramework() { result = "urllib2.Request" }

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
   * - https://docs.python.org/2/library/urllib2.html#urllib2.urlopen
   */
  private class UrlOpenCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
    UrlOpenCall() { this = API::moduleImport("urllib2").getMember("urlopen").getACall() }

    override DataFlow::Node getAUrlPart() { result in [this.getArg(0), this.getArgByName("url")] }

    override string getFramework() { result = "urllib2.urlopen" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      // will validate certificate by default
      // TODO: Handling of insecure SSLContext passed to context argument
      none()
    }
  }
}
