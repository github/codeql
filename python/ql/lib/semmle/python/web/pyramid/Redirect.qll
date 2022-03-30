/**
 * Provides class representing the `pyramid.redirect` function.
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http

deprecated private ClassValue redirectClass() {
  exists(ModuleValue ex | ex.getName() = "pyramid.httpexceptions" |
    ex.attr("HTTPFound") = result
    or
    ex.attr("HTTPTemporaryRedirect") = result
  )
}

/**
 * Represents an argument to the `tornado.redirect` function.
 */
deprecated class PyramidRedirect extends HttpRedirectTaintSink {
  override string toString() { result = "pyramid.redirect" }

  PyramidRedirect() {
    exists(CallNode call | call.getFunction().pointsTo(redirectClass()) |
      call.getArg(0) = this
      or
      call.getArgByName("location") = this
    )
  }
}
