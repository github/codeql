/**
 * Provides class representing the `tornado.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
import Tornado

/**
 * Represents an argument to the `tornado.redirect` function.
 */
class TornadoHttpRequestHandlerRedirect extends HttpRedirectTaintSink {
  override string toString() { result = "tornado.HttpRequestHandler.redirect" }

  TornadoHttpRequestHandlerRedirect() {
    exists(CallNode call, ControlFlowNode node |
      node = call.getFunction().(AttrNode).getObject("redirect") and
      isTornadoRequestHandlerInstance(node) and
      this = call.getArg(0)
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}
