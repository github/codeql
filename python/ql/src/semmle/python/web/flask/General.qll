import python
import semmle.python.web.Http

/** The flask module */
ModuleObject theFlaskModule() {
    result = ModuleObject::named("flask")
}

/** The flask app class */
ClassObject theFlaskClass() {
    result = theFlaskModule().attr("Flask")
}

/** The flask MethodView class */
ClassObject theFlaskMethodViewClass() {
    result = ModuleObject::named("flask.views").attr("MethodView")
}

ClassObject theFlaskReponseClass() {
    result = theFlaskModule().attr("Response")
}

/** Holds if `route` is routed to `func`
 * by decorating `func` with `app.route(route)`
 */
predicate app_route(ControlFlowNode route, Function func) {
    exists(CallNode route_call, CallNode decorator_call |
        route_call.getFunction().(AttrNode).getObject("route").refersTo(_, theFlaskClass(), _) and
        decorator_call.getFunction() = route_call and
        route_call.getArg(0) = route and
        decorator_call.getArg(0).getNode().(FunctionExpr).getInnerScope() = func
    )
}

/* Helper for add_url_rule */
private predicate add_url_rule_call(ControlFlowNode regex, ControlFlowNode callable) {
    exists(CallNode call |
        call.getFunction().(AttrNode).getObject("add_url_rule").refersTo(_, theFlaskClass(), _) and
        regex = call.getArg(0) |
        callable = call.getArg(2) or
        callable = call.getArgByName("view_func")
    )
}

/** Holds if urls matching `regex` are routed to `func` */
predicate add_url_rule(ControlFlowNode regex, Function func) {
    exists(ControlFlowNode callable |
        add_url_rule_call(regex, callable)
        |
        exists(PyFunctionObject f | f.getFunction() = func and callable.refersTo(f))
        or
        /* MethodView.as_view() */
        exists(MethodViewClass view_cls |
            view_cls.asTaint().taints(callable) |
            func = view_cls.lookupAttribute(httpVerbLower()).(FunctionObject).getFunction()
        )
        /* TO DO -- Handle Views that aren't MethodViews */
    )
}

/** Holds if urls matching `regex` are routed to `func` using 
 * any of flask's routing mechanisms.
 */
predicate flask_routing(ControlFlowNode regex, Function func) {
    app_route(regex, func)
    or
    add_url_rule(regex, func)
}

/** A class that extends flask.views.MethodView */
private class MethodViewClass extends ClassObject {

    MethodViewClass() {
        this.getAnImproperSuperType() = theFlaskMethodViewClass()
    }

    /* As we are restricted to strings for taint kinds, we need to map these classes to strings. */
    string taintString() {
        result = "flask/" + this.getQualifiedName() +  ".as.view"
    }

    /* As we are restricted to strings for taint kinds, we need to map these classes to strings. */
    TaintKind asTaint() {
        result = this.taintString()
    }
}

private class MethodViewTaint extends TaintKind {

    MethodViewTaint() {
        any(MethodViewClass cls).taintString() = this
    }
}

/** A source of method view "taint"s. */
private class AsView extends TaintSource {

    AsView() {
        exists(ClassObject view_class |
            view_class.getAnImproperSuperType() = theFlaskMethodViewClass() and
            this.(CallNode).getFunction().(AttrNode).getObject("as_view").refersTo(view_class)
        )
    }

    override string toString() {
        result = "flask.MethodView.as_view()"
    }

    override predicate isSourceOf(TaintKind kind) {
        exists(MethodViewClass view_class |
            kind = view_class.asTaint() and
            this.(CallNode).getFunction().(AttrNode).getObject("as_view").refersTo(view_class)
        )
    }

}


class FlaskCookieSet extends CookieSet, CallNode {

    FlaskCookieSet() {
        this.getFunction().(AttrNode).getObject("set_cookie").refersTo(_, theFlaskReponseClass(), _)
    }

    override string toString() { result = CallNode.super.toString() }

    override ControlFlowNode getKey() { result = this.getArg(0) }

    override ControlFlowNode getValue() { result = this.getArg(1) }


}
