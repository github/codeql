import python
import semmle.python.dataflow.Implementation
import semmle.python.security.strings.External
import HttpConstants

/** Generic taint source from a http request */
abstract class HttpRequestTaintSource extends TaintSource { }

/**
 * Taint kind representing the WSGI environment.
 * As specified in PEP 3333. https://www.python.org/dev/peps/pep-3333/#environ-variables
 */
class WsgiEnvironment extends TaintKind {
  WsgiEnvironment() { this = "wsgi.environment" }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    result = this and Implementation::copyCall(fromnode, tonode)
    or
    result = this and
    tonode.(CallNode).getFunction().pointsTo(ClassValue::dict()) and
    tonode.(CallNode).getArg(0) = fromnode
    or
    exists(Value key, string text |
      tonode.(CallNode).getFunction().(AttrNode).getObject("get") = fromnode and
      tonode.(CallNode).getArg(0).pointsTo(key)
      or
      tonode.(SubscriptNode).getObject() = fromnode and
      tonode.isLoad() and
      tonode.(SubscriptNode).getIndex().pointsTo(key)
    |
      key = Value::forString(text) and
      result instanceof ExternalStringKind and
      (
        text = "QUERY_STRING" or
        text = "PATH_INFO" or
        text.prefix(5) = "HTTP_"
      )
    )
  }
}

/**
 * A standard morsel object from a HTTP request, a value in a cookie,
 * typically an instance of `http.cookies.Morsel`
 */
class UntrustedMorsel extends TaintKind {
  UntrustedMorsel() { this = "http.Morsel" }

  override TaintKind getTaintOfAttribute(string name) {
    result instanceof ExternalStringKind and
    name = "value"
  }
}

/** A standard cookie object from a HTTP request, typically an instance of `http.cookies.SimpleCookie` */
class UntrustedCookie extends TaintKind {
  UntrustedCookie() { this = "http.Cookie" }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    tonode.(SubscriptNode).getObject() = fromnode and
    result instanceof UntrustedMorsel
  }
}

abstract class CookieOperation extends @py_flow_node {
  /** Gets a textual representation of this element. */
  abstract string toString();

  abstract ControlFlowNode getKey();

  abstract ControlFlowNode getValue();
}

abstract class CookieGet extends CookieOperation { }

abstract class CookieSet extends CookieOperation { }

/** Generic taint sink in a http response */
abstract class HttpResponseTaintSink extends TaintSink {
  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

abstract class HttpRedirectTaintSink extends TaintSink {
  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

module Client {
  // TODO: user-input in other than URL:
  // - `data`, `json` for `requests.post`
  // - `body` for `HTTPConnection.request`
  // - headers?
  // TODO: Add more library support
  // - urllib3 https://github.com/urllib3/urllib3
  // - httpx https://github.com/encode/httpx
  /**
   * An outgoing http request
   *
   * For example:
   * conn = HTTPConnection('example.com')
   *        conn.request('GET', '/path')
   */
  abstract class HttpRequest extends ControlFlowNode {
    /**
     * Get any ControlFlowNode that is used to construct the final URL.
     *
     * In the HTTPConnection example, there is a result for both `'example.com'` and for `'/path'`.
     */
    abstract ControlFlowNode getAUrlPart();

    abstract string getMethodUpper();
  }

  /** Taint sink for the URL-part of an outgoing http request */
  class HttpRequestUrlTaintSink extends TaintSink {
    HttpRequestUrlTaintSink() { this = any(HttpRequest r).getAUrlPart() }

    override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
  }
}
