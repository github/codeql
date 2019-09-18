import python


import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic
private import semmle.python.web.Http

import Tornado

class TornadoConnection extends TaintKind {

    TornadoConnection() {
        this = "tornado.http.connection"
    }

}

class TornadoConnectionSource extends TaintSource {

    TornadoConnectionSource() {
        isTornadoRequestHandlerInstance(this.(AttrNode).getObject("connection"))
    }

    override string toString() {
        result = "Tornado http connection source"
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof TornadoConnection
    }

}

class TornadoConnectionWrite extends HttpResponseTaintSink {

    override string toString() {
        result = "tornado.connection.write"
    }

    TornadoConnectionWrite() {
        exists(CallNode call, ControlFlowNode conn |
            conn = call.getFunction().(AttrNode).getObject("write") and
            this = call.getAnArg() |
            exists(TornadoConnection tc | tc.taints(conn))
            or
            isTornadoRequestHandlerInstance(conn)
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}

class TornadoHttpRequestHandlerWrite extends HttpResponseTaintSink {

    override string toString() {
        result = "tornado.HttpRequesHandler.write"
    }

    TornadoHttpRequestHandlerWrite() {
        exists(CallNode call, ControlFlowNode node |
            node = call.getFunction().(AttrNode).getObject("write") and
            isTornadoRequestHandlerInstance(node) and
            this = call.getAnArg()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}

class TornadoHttpRequestHandlerRedirect extends HttpResponseTaintSink {

    override string toString() {
        result = "tornado.HttpRequesHandler.redirect"
    }

    TornadoHttpRequestHandlerRedirect() {
        exists(CallNode call, ControlFlowNode node |
            node = call.getFunction().(AttrNode).getObject("redirect") and
            isTornadoRequestHandlerInstance(node) and
            this = call.getArg(0)
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}



