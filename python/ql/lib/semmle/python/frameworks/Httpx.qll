/**
 * Provides classes modeling security-relevant aspects of the `httpx` PyPI package.
 *
 * See
 * - https://pypi.org/project/httpx/
 * - https://www.python-httpx.org/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `httpx` PyPI package.
 *
 * See
 * - https://pypi.org/project/httpx/
 * - https://www.python-httpx.org/
 */
module HttpxModel {
  /**
   * An outgoing HTTP request, from the `httpx` library.
   *
   * See https://www.python-httpx.org/api/
   */
  private class RequestCall extends Http::Client::Request::Range, API::CallNode {
    string methodName;

    RequestCall() {
      methodName in [Http::httpVerbLower(), "request", "stream"] and
      this = API::moduleImport("httpx").getMember(methodName).getACall()
    }

    override DataFlow::Node getAUrlPart() {
      result = this.getArgByName("url")
      or
      if methodName in ["request", "stream"]
      then result = this.getArg(1)
      else result = this.getArg(0)
    }

    override string getFramework() { result = "httpx" }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      disablingNode = this.getKeywordParameter("verify").asSink() and
      argumentOrigin = this.getKeywordParameter("verify").getAValueReachingSink() and
      // unlike `requests`, httpx treats `None` as turning off verify (and not as the default)
      argumentOrigin.asExpr().(ImmutableLiteral).booleanValue() = false
      // TODO: Handling of insecure SSLContext passed to verify argument
    }
  }

  /**
   * Provides models for the `httpx.[Async]Client` class
   *
   * See https://www.python-httpx.org/api/#client
   */
  module Client {
    /** Get a reference to the `httpx.Client` or `httpx.AsyncClient` class. */
    API::Node classRef() {
      result = API::moduleImport("httpx").getMember(["Client", "AsyncClient"])
      or
      result = ModelOutput::getATypeNode("httpx.Client~Subclass").getASubclass*()
    }

    /** A method call on a Client that sends off a request */
    private class OutgoingRequestCall extends Http::Client::Request::Range, DataFlow::CallCfgNode {
      string methodName;

      OutgoingRequestCall() {
        methodName in [Http::httpVerbLower(), "request", "stream"] and
        this = classRef().getReturn().getMember(methodName).getACall()
      }

      override DataFlow::Node getAUrlPart() {
        result = this.getArgByName("url")
        or
        if methodName in ["request", "stream"]
        then result = this.getArg(1)
        else result = this.getArg(0)
      }

      override string getFramework() { result = "httpx.[Async]Client" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        exists(API::CallNode constructor |
          constructor = classRef().getACall() and
          this = constructor.getReturn().getMember(methodName).getACall()
        |
          disablingNode = constructor.getKeywordParameter("verify").asSink() and
          argumentOrigin = constructor.getKeywordParameter("verify").getAValueReachingSink() and
          // unlike `requests`, httpx treats `None` as turning off verify (and not as the default)
          argumentOrigin.asExpr().(ImmutableLiteral).booleanValue() = false
          // TODO: Handling of insecure SSLContext passed to verify argument
        )
      }
    }
  }
}
