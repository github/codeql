import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.web.Http
import semmle.python.web.bottle.General

/**
 * A bottle.Response object
 * This isn't really a "taint", but we use the value tracking machinery to
 * track the flow of response objects.
 */
class BottleResponse extends TaintKind {
  BottleResponse() { this = "bottle.response" }
}

private Value theBottleResponseObject() { result = theBottleModule().attr("response") }

class BottleResponseBodyAssignment extends HttpResponseTaintSink {
  BottleResponseBodyAssignment() {
    exists(DefinitionNode lhs |
      lhs.getValue() = this and
      lhs.(AttrNode).getObject("body").pointsTo(theBottleResponseObject())
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}

class BottleHandlerFunctionResult extends HttpResponseTaintSink {
  BottleHandlerFunctionResult() {
    exists(BottleRoute route, Return ret |
      ret.getScope() = route.getFunction() and
      ret.getValue().getAFlowNode() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }

  override string toString() { result = "bottle handler function result" }
}

class BottleCookieSet extends CookieSet, CallNode {
  BottleCookieSet() {
    any(BottleResponse r).taints(this.getFunction().(AttrNode).getObject("set_cookie"))
  }

  override string toString() { result = CallNode.super.toString() }

  override ControlFlowNode getKey() { result = this.getArg(0) }

  override ControlFlowNode getValue() { result = this.getArg(1) }
}
