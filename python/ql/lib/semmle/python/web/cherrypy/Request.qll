import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
import semmle.python.web.cherrypy.General

/** The cherrypy.request local-proxy object */
deprecated class CherryPyRequest extends TaintKind {
  CherryPyRequest() { this = "cherrypy.request" }

  override TaintKind getTaintOfAttribute(string name) {
    name = "params" and result instanceof ExternalStringDictKind
    or
    name = "cookie" and result instanceof UntrustedCookie
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name in ["getHeader", "getCookie", "getUser", "getPassword"] and
    result instanceof ExternalStringKind
  }
}

deprecated class CherryPyExposedFunctionParameter extends HttpRequestTaintSource {
  CherryPyExposedFunctionParameter() {
    exists(Parameter p |
      p = any(CherryPyExposedFunction f).getAnArg() and
      not p.isSelf() and
      p.asName().getAFlowNode() = this
    )
  }

  override string toString() { result = "CherryPy handler function parameter" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }
}

deprecated class CherryPyRequestSource extends HttpRequestTaintSource {
  CherryPyRequestSource() { this.(ControlFlowNode).pointsTo(Value::named("cherrypy.request")) }

  override predicate isSourceOf(TaintKind kind) { kind instanceof CherryPyRequest }
}
