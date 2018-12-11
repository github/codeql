/** Provides class representing the `tornado.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */
import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic
import Tornado


/**
 * Represents an argument to the `tornado.redirect` function.
 */
class TornadoRedirect extends TaintSink {

    override string toString() {
        result = "tornado.redirect"
    }

    TornadoRedirect() {
        exists(CallNode call, ControlFlowNode node |
            node = call.getFunction().(AttrNode).getObject("redirect") and
            isTornadoRequestHandlerInstance(node) and
            this = call.getAnArg()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}
