import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
private import semmle.python.web.pyramid.View
private import semmle.python.web.Http

/**
 * A pyramid response, which is vulnerable to any sort of
 * http response malice.
 */
class PyramidRoutedResponse extends HttpResponseTaintSink {
  PyramidRoutedResponse() {
    exists(PythonFunctionValue view |
      is_pyramid_view_function(view.getScope()) and
      this = view.getAReturnedNode()
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }

  override string toString() { result = "pyramid.routed.response" }
}

class PyramidCookieSet extends CookieSet, CallNode {
  PyramidCookieSet() {
    exists(ControlFlowNode f |
      f = this.getFunction().(AttrNode).getObject("set_cookie") and
      f.pointsTo().getClass() = Value::named("pyramid.response.Response")
    )
  }

  override string toString() { result = CallNode.super.toString() }

  override ControlFlowNode getKey() { result = this.getArg(0) }

  override ControlFlowNode getValue() { result = this.getArg(1) }
}
