import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import Twisted

/** A twisted.web.http.Request object */
class TwistedRequest extends TaintKind {
  TwistedRequest() { this = "twisted.request.http.Request" }

  override TaintKind getTaintOfAttribute(string name) {
    result instanceof ExternalStringSequenceDictKind and
    name = "args"
    or
    result instanceof ExternalStringKind and
    name = "uri"
  }

  override TaintKind getTaintOfMethodResult(string name) {
    (
      name = "getHeader" or
      name = "getCookie" or
      name = "getUser" or
      name = "getPassword"
    ) and
    result instanceof ExternalStringKind
  }
}

class TwistedRequestSource extends HttpRequestTaintSource {
  TwistedRequestSource() { isTwistedRequestInstance(this) }

  override string toString() { result = "Twisted request source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TwistedRequest }
}
