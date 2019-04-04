import python


import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic

private import semmle.python.web.pyramid.View
private import semmle.python.web.Http

/** A pyramid response, which is vulnerable to any sort of 
 * http response malice. */
class PyramidRoutedResponse extends HttpResponseTaintSink {

    PyramidRoutedResponse() {
        exists(PyFunctionObject view |
            is_pyramid_view_function(view.getFunction()) and
            this = view.getAReturnedNode()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

    override string toString() {
        result = "pyramid.routed.response"
    }

}
