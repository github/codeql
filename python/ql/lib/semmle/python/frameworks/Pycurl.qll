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
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `pycurl` PyPI package.
 *
 * See
 * - https://pypi.org/project/pycurl/
 * - https://pycurl.io/docs/latest/
 */
module Pycurl {
  /**
   * Provides models for the `pycurl.Curl` class
   *
   * See https://pycurl.io/docs/latest/curl.html.
   */
  module Curl {
    /** Gets a reference to the `pycurl.Curl` class. */
    API::Node classRef() {
      result = API::moduleImport("pycurl").getMember("Curl")
      or
      result = ModelOutput::getATypeNode("pycurl.Curl~Subclass").getASubclass*()
    }

    /** Gets a reference to an instance of `pycurl.Curl`. */
    private API::Node instance() { result = classRef().getReturn() }

    /** Gets a reference to an instance of `pycurl.Curl.setopt`. */
    private API::Node setopt() { result = instance().getMember("setopt") }

    /** Gets a reference to an instance of `pycurl.Curl.SSL_VERIFYPEER`. */
    private API::Node sslverifypeer() {
      result = API::moduleImport("pycurl").getMember("SSL_VERIFYPEER") or
      result = instance().getMember("SSL_VERIFYPEER")
    }

    /**
     * When the first parameter value of the `setopt` function is set to `pycurl.URL`,
     * the second parameter value is the request resource link.
     *
     * See http://pycurl.io/docs/latest/curlobject.html#pycurl.Curl.setopt.
     */
    private class OutgoingRequestCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
      OutgoingRequestCall() {
        this = setopt().getACall() and
        this.getArg(0).asCfgNode().(AttrNode).getName() = "URL"
      }

      override DataFlow::Node getAUrlPart() {
        result in [this.getArg(1), this.getArgByName("value")]
      }

      override string getFramework() { result = "pycurl.Curl" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        none()
      }
    }

    /**
     * When the first parameter value of the `setopt` function is set to `SSL_VERIFYPEER` or `SSL_VERIFYHOST`,
     * the second parameter value disables or enable SSL certifiacte verification.
     *
     * See http://pycurl.io/docs/latest/curlobject.html#pycurl.Curl.setopt.
     */
    private class CurlSslCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
      CurlSslCall() {
        this = setopt().getACall() and
        this.getArg(0).asCfgNode().(AttrNode).getName() = ["SSL_VERIFYPEER", "SSL_VERIFYHOST"]
      }

      override DataFlow::Node getAUrlPart() { none() }

      override string getFramework() { result = "pycurl.Curl" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        exists(API::CallNode c |
          c = setopt().getACall() and
          sslverifypeer().getAValueReachableFromSource() = c.getArg(0) and
          (
            exists(IntegerLiteral i | i.getValue() = 0 and c.getArg(1).asExpr() = i)
            or
            exists(BooleanLiteral b | b.booleanValue() = false)
          )
        |
          disablingNode = c and argumentOrigin = c.getArg(1)
        )
      }
    }
  }
}
