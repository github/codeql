/**
 * Modeling outgoing HTTP requests using the `requests` package
 * https://pypi.org/project/requests/
 */

import python
private import semmle.python.web.Http

class RequestsHttpRequest extends Client::HttpRequest, CallNode {
  CallableValue func;
  string method;

  RequestsHttpRequest() {
    method = httpVerbLower() and
    func = Module::named("requests").attr(method) and
    this = func.getACall()
  }

  override ControlFlowNode getAUrlPart() { result = func.getNamedArgumentForCall(this, "url") }

  override string getMethodUpper() { result = method.toUpperCase() }
}
