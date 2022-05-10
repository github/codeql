/**
 * Provides classes modeling security-relevant aspects of the `pycurl` PyPI package.
 *
 * See
 * - https://pypi.org/project/pycurl/
 * - https://pycurl.io/docs/latest/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `pycurl` PyPI package.
 *
 * See
 * - https://pypi.org/project/pycurl/
 * - https://pycurl.io/docs/latest/
 */
private module Pycurl {
  /**
   * Provides models for the `pycurl.Curl` class
   *
   * See https://pycurl.io/docs/latest/curl.html.
   */
  module Curl {
    /** Gets a reference to the `pycurl.Curl` class. */
    private API::Node classRef() { result = API::moduleImport("pycurl").getMember("Curl") }

    /** Gets a reference to an instance of `pycurl.Curl`. */
    private API::Node instance() { result = classRef().getReturn() }

    /**
     * When the first parameter value of the `setopt` function is set to `pycurl.URL`,
     * the second parameter value is the request resource link.
     *
     * See http://pycurl.io/docs/latest/curlobject.html#pycurl.Curl.setopt.
     */
    private class OutgoingRequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      OutgoingRequestCall() {
        this = instance().getMember("setopt").getACall() and
        this.getArg(0).asCfgNode().(AttrNode).getName() = "URL"
      }

      override DataFlow::Node getAUrlPart() {
        result in [this.getArg(1), this.getArgByName("value")]
      }

      override string getFramework() { result = "pycurl.Curl" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Look into disabling certificate validation
        none()
      }
    }
  }
}
