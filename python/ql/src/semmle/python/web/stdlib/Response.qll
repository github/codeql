/**
 * Provides the sinks for HTTP servers defined with standard library (stdlib).
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http

private predicate is_wfile(AttrNode wfile) {
  exists(ClassValue cls |
    // Python 2
    cls.getABaseType+() = Value::named("BaseHTTPServer.BaseHTTPRequestHandler")
    or
    // Python 3
    cls.getABaseType+() = Value::named("http.server.BaseHTTPRequestHandler")
  |
    wfile.getObject("wfile").pointsTo().getClass() = cls
  )
}

/** Sink for `h.wfile.write` where `h` is an instance of BaseHTTPRequestHandler. */
class StdLibWFileWriteSink extends HttpResponseTaintSink {
  StdLibWFileWriteSink() {
    exists(CallNode call |
      is_wfile(call.getFunction().(AttrNode).getObject("write")) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/** Sink for `h.wfile.writelines` where `h` is an instance of BaseHTTPRequestHandler. */
class StdLibWFileWritelinesSink extends HttpResponseTaintSink {
  StdLibWFileWritelinesSink() {
    exists(CallNode call |
      is_wfile(call.getFunction().(AttrNode).getObject("writelines")) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringSequenceKind }
}
