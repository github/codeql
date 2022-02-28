/**
 * Provides classes modeling security-relevant aspects of the `libtaxii` PyPI package.
 * See https://github.com/TAXIIProject/libtaxii
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `libtaxii` PyPI package.
 * see https://github.com/TAXIIProject/libtaxii
 */
module Libtaxii {
  /**
   * A call to `libtaxii.common.parse`.
   * When the `allow_url` parameter value is set to `True`, there is an SSRF vulnerability..
   */
  private class ParseCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
    ParseCall() {
      this = API::moduleImport("libtaxii").getMember("common").getMember("parse").getACall() and
      this.getArgByName("allow_url").asExpr().toString() = "True"
    }

    DataFlow::Node getUrlArg() { result in [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getAUrlPart() { result = this.getUrlArg() }

    override string getFramework() { result = "libtaxii.common.parse" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      none()
    }
  }
}
