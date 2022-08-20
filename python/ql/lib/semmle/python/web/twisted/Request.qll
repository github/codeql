import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import Twisted

/** A twisted.web.http.Request object */
deprecated class TwistedRequest extends TaintKind {
  TwistedRequest() { this = "twisted.request.http.Request" }

  override TaintKind getTaintOfAttribute(string name) {
    result instanceof ExternalStringSequenceDictKind and
    name = "args"
    or
    result instanceof ExternalStringKind and
    name = "uri"
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name in ["getHeader", "getCookie", "getUser", "getPassword"] and
    result instanceof ExternalStringKind
  }
}

deprecated class TwistedRequestSource extends HttpRequestTaintSource {
  TwistedRequestSource() { isTwistedRequestInstance(this) }

  override string toString() { result = "Twisted request source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TwistedRequest }
}
