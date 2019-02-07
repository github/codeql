import python
import semmle.python.web.Http


/** The falcon API class */
ClassObject theFalconAPIClass() {
    result = ModuleObject::named("falcon").getAttribute("API")
}


/** Holds if `route` is routed to `resource`
 */
private predicate api_route(CallNode route_call, ControlFlowNode route, ClassObject resource) {
    route_call.getFunction().(AttrNode).getObject("add_route").refersTo(_, theFalconAPIClass(), _) and
    route_call.getArg(0) = route and
    route_call.getArg(1).refersTo(_, resource, _)
}

class FalconRoute extends ControlFlowNode {

    FalconRoute() {
        api_route(this, _, _)
    }

    string getUrl() {
        exists(StrConst url |
            api_route(this, url.getAFlowNode(), _) and
            result = url.getText()
        )
    }

    ClassObject getResourceClass() {
        api_route(this, _, result)
    }

    FalconHandlerFunction getHandlerFunction() {
        result = this.getResourceClass().lookupAttribute(_).(FunctionObject).getFunction()
    }

    FalconHandlerFunction getHandlerFunction(string method) {
        result = this.getResourceClass().lookupAttribute("on_" + method).(FunctionObject).getFunction()
    }

}

class FalconHandlerFunction extends Function {

    string method;

    FalconHandlerFunction() {
        exists(ClassObject resource |
            resource.lookupAttribute("on_" + method).(FunctionObject).getFunction() = this
        )
    }

    string getMethod() {
        result = method.toUpperCase()
    }

    Parameter getRequest() {
        result = this.getArg(1)
    }

    Parameter getResponse() {
        result = this.getArg(2)
    }

}
