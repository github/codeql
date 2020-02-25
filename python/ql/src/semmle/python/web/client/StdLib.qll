import python
private import semmle.python.web.Http

ClassValue httpConnectionClass() {
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

class HttpConnectionHttpRequest extends Client::HttpRequest, CallNode {
    CallNode constructor_call;
    CallableValue func;

    HttpConnectionHttpRequest() {
        exists(ClassValue cls, AttrNode call_origin, Value constructor_call_value |
            cls = httpConnectionClass() and
            func = cls.lookup("request") and
            this = func.getACall() and
            this.getFunction().pointsTo(_, _, call_origin) and
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
