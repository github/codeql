import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
private import semmle.python.web.Http
import Tornado

class TornadoConnection extends TaintKind {
  TornadoConnection() { this = "tornado.http.connection" }
}

class TornadoConnectionSource extends TaintSource {
  TornadoConnectionSource() {
    isTornadoRequestHandlerInstance(this.(AttrNode).getObject("connection"))
  }

  override string toString() { result = "Tornado http connection source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TornadoConnection }
}

class TornadoConnectionWrite extends HttpResponseTaintSink {
  override string toString() { result = "tornado.connection.write" }

  TornadoConnectionWrite() {
    exists(CallNode call, ControlFlowNode conn |
      conn = call.getFunction().(AttrNode).getObject("write") and
      this = call.getAnArg() and
      exists(TornadoConnection tc | tc.taints(conn))
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}

class TornadoHttpRequestHandlerWrite extends HttpResponseTaintSink {
  override string toString() { result = "tornado.HttpRequestHandler.write" }

  TornadoHttpRequestHandlerWrite() {
    exists(CallNode call, ControlFlowNode node |
      node = call.getFunction().(AttrNode).getObject("write") and
      this = call.getAnArg() and
      isTornadoRequestHandlerInstance(node)
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}
