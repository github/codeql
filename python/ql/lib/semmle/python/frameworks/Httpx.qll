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

/**
 * Provides models for the `httpx` PyPI package.
 *
 * See
 * - https://pypi.org/project/httpx/
 * - https://www.python-httpx.org/
 */
private module HttpxModel {
  private class RequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
    string methodName;

    RequestCall() {
      methodName in [HTTP::httpVerbLower(), "request", "stream"] and
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
      // TODO: Look into disabling certificate validation
      none()
    }
  }

  /**
   * Provides models for the `httpx.[Async]Client` class
   *
   * See https://www.python-httpx.org/async/
   */
  module Client {
    /** Get a reference to the `httpx.Client` or `httpx.AsyncClient` class. */
    private API::Node classRef() {
      result = API::moduleImport("httpx").getMember(["Client", "AsyncClient"])
    }

    /** Get a reference to an `httpx.Client` or `httpx.AsyncClient` instance. */
    private API::Node instance() { result = classRef().getReturn() }

    /** A method call on a Client that sends off a request */
    private class OutgoingRequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
      string methodName;

      OutgoingRequestCall() {
        methodName in [HTTP::httpVerbLower(), "request", "stream"] and
        this = instance().getMember(methodName).getACall()
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
        // TODO: Look into disabling certificate validation
        none()
      }
    }
  }
}
