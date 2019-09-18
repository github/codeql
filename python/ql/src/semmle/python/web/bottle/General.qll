import python
import semmle.python.web.Http
import semmle.python.types.Extensions

/** The bottle module */
ModuleObject theBottleModule() {
    result = ModuleObject::named("bottle")
}

/** The bottle.Bottle class */
ClassObject theBottleClass() {
    result = theBottleModule().attr("Bottle")
}

/** Holds if `route` is routed to `func`
 * by decorating `func` with `app.route(route)` or `route(route)`
 */
predicate bottle_route(CallNode route_call, ControlFlowNode route, Function func) {
    exists(CallNode decorator_call, string name |
        route_call.getFunction().(AttrNode).getObject(name).refersTo(_, theBottleClass(), _) or
        route_call.getFunction().refersTo(theBottleModule().attr(name))
        |
        (name = "route" or name = httpVerbLower()) and
        decorator_call.getFunction() = route_call and
        route_call.getArg(0) = route and
        decorator_call.getArg(0).getNode().(FunctionExpr).getInnerScope() = func
    )
}

class BottleRoute extends ControlFlowNode {

    BottleRoute() {
        bottle_route(this, _, _)
    }

    string getUrl() {
        exists(StrConst url |
            bottle_route(this, url.getAFlowNode(), _) and
            result = url.getText()
        )
    }

    Function getFunction() {
        bottle_route(this, _, result)
    }

    Parameter getNamedArgument() {
        exists(string name, Function func |
            func = this.getFunction() and
            func.getArgByName(name) = result and
            this.getUrl().matches("%<" + name + ">%")
        )
    }
}


