import python
import semmle.python.web.Http
import semmle.python.types.Extensions

/** The bottle module */
ModuleValue theBottleModule() { result = Module::named("bottle") }

/** The bottle.Bottle class */
ClassValue theBottleClass() { result = theBottleModule().attr("Bottle") }

/**
 * Holds if the CFN `route` (representing some string) is set up for routing to `func` through Bottle.
 *
 * This can be done in many ways, but usually by decorating `func` with the `@bottle.route` decorator
 * (or decorating with `@bottle.get`, `@bottle.get`, etc.). These decorators can also be accessed from an
 * instance of a Bottle application, for example by decorating with `@app.route(route)` or `@app.post(route)`.
 * See:
 * - https://bottlepy.org/docs/dev/api.html#routing
 * - https://bottlepy.org/docs/dev/api.html#bottle.Bottle.route
 */
predicate bottle_route(CallNode route_call, ControlFlowNode route, Function func) {
    exists(CallNode decorator_call, string name |
        route_call.getFunction().(AttrNode).getObject(name).pointsTo().getClass() = theBottleClass() or
        route_call.getFunction().pointsTo(theBottleModule().attr(name))
    |
        (name = "route" or name = httpVerbLower()) and
        decorator_call.getFunction() = route_call and
        route_call.getArg(0) = route and
        decorator_call.getArg(0).getNode().(FunctionExpr).getInnerScope() = func
    )
}

class BottleRoute extends ControlFlowNode {
    BottleRoute() { bottle_route(this, _, _) }

    /** DEPRECATED: Use `getUrlPattern` instead */
    deprecated string getUrl() { result = this.getUrlPattern() }

    /** Gets the URL pattern this route will listen to */
    string getUrlPattern() {
        exists(StrConst route |
            bottle_route(this, route.getAFlowNode(), _) and
            result = route.getText()
        )
    }

    Function getFunction() { bottle_route(this, _, result) }

    Parameter getANamedArgument() {
        exists(string name, Function func |
            func = this.getFunction() and
            func.getArgByName(name) = result and
            exists(string match |
                // see https://bottlepy.org/docs/dev/tutorial.html#dynamic-routes
                match = this.getUrlPattern().regexpFind(bottle_rule_syntax_re(), _, _) and
                (
                    // for normal `<arg>` or `<arg:filter>`
                    name = match.regexpCapture(bottle_rule_syntax_re(), 5)
                    or
                    // for deprecated `:arg`
                    name = match.regexpCapture(bottle_rule_syntax_re(), 2)
                )
            )
        )
    }
}

private string bottle_rule_syntax_re() {
    // taken from https://github.com/bottlepy/bottle/blob/332215b2b1b3de5a321ba9f3497777fc93662893/bottle.py#L349-L352
    // note: I used https://regex101.com/ to find the group numbers on sample input, and verified manually.
    //       https://www.debuggex.com/ was very helpful in visualizing the regex
    result =
        "(\\\\*)(?:(?::([a-zA-Z_][a-zA-Z_0-9]*)?()(?:#(.*?)#)?)|(?:<([a-zA-Z_][a-zA-Z_0-9]*)?(?::([a-zA-Z_]*)(?::((?:\\\\.|[^\\\\>])+)?)?)?>))"
}
