/**
 * Provides the sources and taint-flow for HTTP servers defined using the standard library (stdlib).
 * Specifically, we model `HttpRequestTaintSource`s from instances of `BaseHTTPRequestHandler`
 * (or subclasses) and form parsing using `cgi.FieldStorage`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http

/** Source of BaseHttpRequestHandler instances. */
deprecated class StdLibRequestSource extends HttpRequestTaintSource {
  StdLibRequestSource() {
    exists(ClassValue cls |
      cls.getABaseType+() = Value::named("BaseHTTPServer.BaseHTTPRequestHandler")
      or
      cls.getABaseType+() = Value::named("http.server.BaseHTTPRequestHandler")
    |
      this.(ControlFlowNode).pointsTo().getClass() = cls
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof BaseHTTPRequestHandlerKind }
}

/** TaintKind for an instance of BaseHttpRequestHandler. */
deprecated class BaseHTTPRequestHandlerKind extends TaintKind {
  BaseHTTPRequestHandlerKind() { this = "BaseHTTPRequestHandlerKind" }

  override TaintKind getTaintOfAttribute(string name) {
    name in ["requestline", "path"] and
    result instanceof ExternalStringKind
    or
    name = "headers" and
    result instanceof HTTPMessageKind
    or
    name = "rfile" and
    result instanceof ExternalFileObject
  }
}

/** TaintKind for headers (instance of HttpMessage). */
deprecated class HTTPMessageKind extends ExternalStringDictKind {
  override TaintKind getTaintOfMethodResult(string name) {
    result = super.getTaintOfMethodResult(name)
    or
    name = "get_all" and
    result.(SequenceKind).getItem() = this.getValue()
    or
    name in ["as_bytes", "as_string"] and
    result instanceof ExternalStringKind
  }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    result = super.getTaintForFlowStep(fromnode, tonode)
    or
    exists(ClassValue cls | cls = ClassValue::unicode() or cls = ClassValue::bytes() |
      tonode = cls.getACall() and
      tonode.(CallNode).getArg(0) = fromnode and
      result instanceof ExternalStringKind
    )
  }
}

/** Source of parsed HTTP forms (by using the `cgi` module). */
deprecated class CgiFieldStorageSource extends HttpRequestTaintSource {
  CgiFieldStorageSource() { this = Value::named("cgi.FieldStorage").getACall() }

  override predicate isSourceOf(TaintKind kind) { kind instanceof CgiFieldStorageFormKind }
}

/** TaintKind for a parsed HTTP form. */
deprecated class CgiFieldStorageFormKind extends TaintKind {
  /*
   * There is a slight difference between how we model form/fields and how it is handled by the code.
   * In the code
   * ```
   * form = cgi.FieldStorage()
   * field = form['myfield']
   * ```
   * both `form` and `field` have the type `cgi.FieldStorage`. This allows the code to represent
   * nested forms as `form['nested_form']['myfield']`. However, since HTML forms can't be nested
   * we ignore that detail since it allows for a more clean modeling.
   */

  CgiFieldStorageFormKind() { this = "CgiFieldStorageFormKind" }

  override TaintKind getTaintOfAttribute(string name) {
    name = "value" and result.(SequenceKind).getItem() instanceof CgiFieldStorageFieldKind
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "getvalue" and
    (
      result instanceof ExternalStringKind
      or
      result.(SequenceKind).getItem() instanceof ExternalStringKind
    )
    or
    name = "getfirst" and
    result instanceof ExternalStringKind
    or
    name = "getlist" and
    result.(SequenceKind).getItem() instanceof ExternalStringKind
  }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    tonode.(SubscriptNode).getObject() = fromnode and
    (
      result instanceof CgiFieldStorageFieldKind
      or
      result.(SequenceKind).getItem() instanceof CgiFieldStorageFieldKind
    )
  }
}

/** TaintKind for the field of a parsed HTTP form. */
deprecated class CgiFieldStorageFieldKind extends TaintKind {
  CgiFieldStorageFieldKind() { this = "CgiFieldStorageFieldKind" }

  override TaintKind getTaintOfAttribute(string name) {
    name in ["filename", "value"] and result instanceof ExternalStringKind
    or
    name = "file" and result instanceof ExternalFileObject
  }
}
