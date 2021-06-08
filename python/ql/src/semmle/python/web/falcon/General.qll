import python
import semmle.python.web.Http

/** The falcon API class */
ClassValue theFalconAPIClass() { result = Value::named("falcon.API") }

/** Holds if `route` is routed to `resource` */
private predicate api_route(CallNode route_call, ControlFlowNode route, ClassValue resource) {
  route_call.getFunction().(AttrNode).getObject("add_route").pointsTo().getClass() =
    theFalconAPIClass() and
  route_call.getArg(0) = route and
  route_call.getArg(1).pointsTo().getClass() = resource
}

private predicate route(FalconRoute route, Function target, string funcname) {
  route.getResourceClass().lookup("on_" + funcname).(FunctionValue).getScope() = target
}

class FalconRoute extends ControlFlowNode {
  FalconRoute() { api_route(this, _, _) }

  string getUrl() {
    exists(StrConst url |
      api_route(this, url.getAFlowNode(), _) and
      result = url.getText()
    )
  }

  ClassValue getResourceClass() { api_route(this, _, result) }

  FalconHandlerFunction getHandlerFunction(string method) { route(this, result, method) }
}

class FalconHandlerFunction extends Function {
  FalconHandlerFunction() { route(_, this, _) }

  private string methodName() { route(_, this, result) }

  string getMethod() { result = this.methodName().toUpperCase() }

  Parameter getRequest() { result = this.getArg(1) }

  Parameter getResponse() { result = this.getArg(2) }
}
