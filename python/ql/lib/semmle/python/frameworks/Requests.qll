/**
 * Provides classes modeling security-relevant aspects of the `requests` PyPI package.
 *
 * See
 * - https://pypi.org/project/requests/
 * - https://docs.python-requests.org/en/latest/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.DataFlow

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `requests` PyPI package.
 *
 * See
 * - https://pypi.org/project/requests/
 * - https://docs.python-requests.org/en/latest/
 */
private module Requests {
  private class OutgoingRequestCall extends HTTP::Client::Request::Range, DataFlow::CallCfgNode {
    string methodName;

    OutgoingRequestCall() {
      methodName in [HTTP::httpVerbLower(), "request"] and
      (
        this = API::moduleImport("requests").getMember(methodName).getACall()
        or
        exists(API::Node moduleExporting, API::Node sessionInstance |
          moduleExporting in [
              API::moduleImport("requests"), //
              API::moduleImport("requests").getMember("sessions")
            ] and
          sessionInstance = moduleExporting.getMember(["Session", "session"]).getReturn()
        |
          this = sessionInstance.getMember(methodName).getACall()
        )
      )
    }

    override DataFlow::Node getUrl() {
      result = this.getArgByName("url")
      or
      not methodName = "request" and
      result = this.getArg(0)
      or
      methodName = "request" and
      result = this.getArg(1)
    }

    override DataFlow::Node getResponseBody() { none() }

    /** Gets the `verify` argument to this outgoing requests call. */
    DataFlow::Node getVerifyArg() { result = this.getArgByName("verify") }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      disablingNode = this.getVerifyArg() and
      argumentOrigin = verifyArgBacktracker(disablingNode) and
      argumentOrigin.asExpr().(ImmutableLiteral).booleanValue() = false and
      not argumentOrigin.asExpr() instanceof None
    }

    override string getFramework() { result = "requests" }
  }

  /** Gets a back-reference to the verify argument `arg`. */
  private DataFlow::TypeTrackingNode verifyArgBacktracker(
    DataFlow::TypeBackTracker t, DataFlow::Node arg
  ) {
    t.start() and
    arg = any(OutgoingRequestCall c).getVerifyArg() and
    result = arg.getALocalSource()
    or
    exists(DataFlow::TypeBackTracker t2 | result = verifyArgBacktracker(t2, arg).backtrack(t2, t))
  }

  /** Gets a back-reference to the verify argument `arg`. */
  private DataFlow::LocalSourceNode verifyArgBacktracker(DataFlow::Node arg) {
    result = verifyArgBacktracker(DataFlow::TypeBackTracker::end(), arg)
  }
}
