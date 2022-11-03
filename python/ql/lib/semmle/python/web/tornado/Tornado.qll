import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http

private ClassValue theTornadoRequestHandlerClass() {
  result = Value::named("tornado.web.RequestHandler")
}

ClassValue aTornadoRequestHandlerClass() {
  result.getABaseType+() = theTornadoRequestHandlerClass()
}

/**
 * Holds if `node` is likely to refer to an instance of a tornado
 * `RequestHandler` class.
 */
predicate isTornadoRequestHandlerInstance(ControlFlowNode node) {
  node.pointsTo().getClass() = aTornadoRequestHandlerClass()
  or
  /*
   * In some cases, the points-to analysis won't capture all instances we care
   * about. For these, we use the following syntactic check. First, that
   * `node` appears inside a method of a subclass of
   * `tornado.web.RequestHandler`:
   */

  node.getScope().getEnclosingScope() = aTornadoRequestHandlerClass().getScope() and
  /* Secondly, that `node` refers to the `self` argument: */
  node.isLoad() and
  node.(NameNode).isSelf()
}

CallNode callToNamedTornadoRequestHandlerMethod(string name) {
  isTornadoRequestHandlerInstance(result.getFunction().(AttrNode).getObject(name))
}

class TornadoCookieSet extends CookieSet, CallNode {
  TornadoCookieSet() {
    exists(ControlFlowNode f |
      f = this.getFunction().(AttrNode).getObject("set_cookie") and
      isTornadoRequestHandlerInstance(f)
    )
  }

  override string toString() { result = CallNode.super.toString() }

  override ControlFlowNode getKey() { result = this.getArg(0) }

  override ControlFlowNode getValue() { result = this.getArg(1) }
}
