import python
import semmle.python.security.TaintTracking
import semmle.python.web.Http

class StdLibRequestSource extends HttpRequestTaintSource {
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

class BaseHTTPRequestHandlerKind extends TaintKind {
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

class HTTPMessageKind extends ExternalStringDictKind {
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
