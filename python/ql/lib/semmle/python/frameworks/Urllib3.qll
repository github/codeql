/**
 * Provides classes modeling security-relevant aspects of the `urllib3` PyPI package.
 *
 * See
 * - https://pypi.org/project/urllib3/
 * - https://urllib3.readthedocs.io/en/stable/reference/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `urllib3` PyPI package.
 *
 * See
 * - https://pypi.org/project/urllib3/
 * - https://urllib3.readthedocs.io/en/stable/reference/
 */
private module Urllib3 {
  /**
   * Provides models for the `urllib3.request.RequestMethods` class and subclasses, such
   * as the `urllib3.PoolManager` class
   *
   * See
   * - https://urllib3.readthedocs.io/en/stable/reference/urllib3.request.html#urllib3.request.RequestMethods
   *
   *
   * https://urllib3.readthedocs.io/en/stable/reference/urllib3.poolmanager.html.
   */
  module PoolManager {
    /** Gets a reference to the `urllib3.PoolManager` class. */
    private API::Node classRef() {
      result =
        API::moduleImport("urllib3")
            .getMember(["PoolManager", "ProxyManager", "HTTPConnectionPool", "HTTPSConnectionPool"])
      or
      result =
        API::moduleImport("urllib3")
            .getMember("request")
            .getMember("RequestMethods")
            .getASubclass+()
    }

    /**
     * A call to a method making an outgoing request.
     *
     * See
     * - https://urllib3.readthedocs.io/en/stable/reference/urllib3.request.html#urllib3.request.RequestMethods
     * - https://urllib3.readthedocs.io/en/stable/reference/urllib3.connectionpool.html#urllib3.HTTPConnectionPool.urlopen
     */
    private class RequestCall extends Http::Client::Request::Range, API::CallNode {
      RequestCall() {
        this =
          classRef()
              .getReturn()
              .getMember(["request", "request_encode_url", "request_encode_body", "urlopen"])
              .getACall()
      }

      override DataFlow::Node getAUrlPart() { result in [this.getArg(1), this.getArgByName("url")] }

      override string getFramework() { result = "urllib3.PoolManager" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        exists(API::CallNode constructor |
          constructor = classRef().getACall() and
          this = constructor.getReturn().getAMember().getACall()
        |
          // cert_reqs
          // see https://urllib3.readthedocs.io/en/stable/user-guide.html?highlight=cert_reqs#certificate-verification
          disablingNode = constructor.getKeywordParameter("cert_reqs").asSink() and
          argumentOrigin = constructor.getKeywordParameter("cert_reqs").getAValueReachingSink() and
          argumentOrigin.asExpr().(StrConst).getText() = "CERT_NONE"
          or
          // assert_hostname
          // see https://urllib3.readthedocs.io/en/stable/reference/urllib3.connectionpool.html?highlight=assert_hostname#urllib3.HTTPSConnectionPool
          disablingNode = constructor.getKeywordParameter("assert_hostname").asSink() and
          argumentOrigin =
            constructor.getKeywordParameter("assert_hostname").getAValueReachingSink() and
          argumentOrigin.asExpr().(BooleanLiteral).booleanValue() = false
        )
      }
    }
  }
}
