import python
private import semmle.python.web.Http

deprecated ClassValue httpConnectionClass() {
  // Python 2
  result = Value::named("httplib.HTTPConnection")
  or
  result = Value::named("httplib.HTTPSConnection")
  or
  // Python 3
  result = Value::named("http.client.HTTPConnection")
  or
  result = Value::named("http.client.HTTPSConnection")
  or
  // six
  result = Value::named("six.moves.http_client.HTTPConnection")
  or
  result = Value::named("six.moves.http_client.HTTPSConnection")
}

deprecated class HttpConnectionHttpRequest extends Client::HttpRequest, CallNode {
  CallNode constructor_call;
  CallableValue func;

  HttpConnectionHttpRequest() {
    exists(ClassValue cls, AttrNode call_origin, Value constructor_call_value |
      cls = httpConnectionClass() and
      func = cls.lookup("request") and
      this = func.getACall() and
      // since you can do `r = conn.request; r('GET', path)`, we need to find the origin
      this.getFunction().pointsTo(_, _, call_origin) and
      // Since HTTPSConnection is a subtype of HTTPConnection, up until this point, `cls` could be either class,
      // because `HTTPSConnection.request == HTTPConnection.request`. To avoid generating 2 results, we filter
      // on the actual class used as the constructor
      call_origin.getObject().pointsTo(_, constructor_call_value, constructor_call) and
      cls = constructor_call_value.getClass() and
      constructor_call = cls.getACall()
    )
  }

  override ControlFlowNode getAUrlPart() {
    result = func.getNamedArgumentForCall(this, "url")
    or
    result = constructor_call.getArg(0)
    or
    result = constructor_call.getArgByName("host")
  }

  override string getMethodUpper() {
    exists(string method |
      result = method.toUpperCase() and
      func.getNamedArgumentForCall(this, "method").pointsTo(Value::forString(method))
    )
  }
}
