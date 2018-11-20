/** Provides class representing the `pyramid.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */
import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic

private ClassObject redirectClass() {
    exists(ModuleObject ex |
        ex.getName() = "pyramid.httpexceptions" |
        ex.getAttribute("HTTPFound") = result
        or
        ex.getAttribute("HTTPTemporaryRedirect") = result
    )
}

/**
 * Represents an argument to the `tornado.redirect` function.
 */
class PyramidRedirect extends TaintSink {

    override string toString() {
        result = "pyramid.redirect"
    }

    PyramidRedirect() {
        exists(CallNode call |
            call.getFunction().refersTo(redirectClass()) 
            |
            call.getArg(0) = this
            or
            call.getArgByName("location") = this
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}
