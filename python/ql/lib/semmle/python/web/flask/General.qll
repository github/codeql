import python
import semmle.python.web.Http
import semmle.python.web.flask.Response

/** Gets the flask app class */
deprecated ClassValue theFlaskClass() { result = Value::named("flask.Flask") }

/** Gets the flask MethodView class */
deprecated ClassValue theFlaskMethodViewClass() { result = Value::named("flask.views.MethodView") }

deprecated ClassValue theFlaskReponseClass() { result = Value::named("flask.Response") }

/**
 * Holds if `route` is routed to `func`
 * by decorating `func` with `app.route(route)`
 */
deprecated predicate app_route(ControlFlowNode route, Function func) {
  exists(CallNode route_call, CallNode decorator_call |
    route_call.getFunction().(AttrNode).getObject("route").pointsTo().getClass() = theFlaskClass() and
    decorator_call.getFunction() = route_call and
    route_call.getArg(0) = route and
    decorator_call.getArg(0).getNode().(FunctionExpr).getInnerScope() = func
  )
}

/* Helper for add_url_rule */
deprecated private predicate add_url_rule_call(ControlFlowNode regex, ControlFlowNode callable) {
  exists(CallNode call |
    call.getFunction().(AttrNode).getObject("add_url_rule").pointsTo().getClass() = theFlaskClass() and
    regex = call.getArg(0)
  |
    callable = call.getArg(2) or
    callable = call.getArgByName("view_func")
  )
}

/** Holds if urls matching `regex` are routed to `func` */
deprecated predicate add_url_rule(ControlFlowNode regex, Function func) {
  exists(ControlFlowNode callable | add_url_rule_call(regex, callable) |
    exists(PythonFunctionValue f | f.getScope() = func and callable.pointsTo(f))
    or
    /* MethodView.as_view() */
    exists(MethodViewClass view_cls | view_cls.asTaint().taints(callable) |
      func = view_cls.lookup(httpVerbLower()).(FunctionValue).getScope()
    )
    /* TODO: -- Handle Views that aren't MethodViews */
  )
}

/**
 * Holds if urls matching `regex` are routed to `func` using
 * any of flask's routing mechanisms.
 */
deprecated predicate flask_routing(ControlFlowNode regex, Function func) {
  app_route(regex, func)
  or
  add_url_rule(regex, func)
}

/** A class that extends flask.views.MethodView */
deprecated private class MethodViewClass extends ClassValue {
  MethodViewClass() { this.getASuperType() = theFlaskMethodViewClass() }

  /* As we are restricted to strings for taint kinds, we need to map these classes to strings. */
  string taintString() { result = "flask/" + this.getQualifiedName() + ".as.view" }

  /* As we are restricted to strings for taint kinds, we need to map these classes to strings. */
  TaintKind asTaint() { result = this.taintString() }
}

deprecated private class MethodViewTaint extends TaintKind {
  MethodViewTaint() { any(MethodViewClass cls).taintString() = this }
}

/** A source of method view "taint"s. */
deprecated private class AsView extends TaintSource {
  AsView() {
    exists(ClassValue view_class |
      view_class.getASuperType() = theFlaskMethodViewClass() and
      this.(CallNode).getFunction().(AttrNode).getObject("as_view").pointsTo(view_class)
    )
  }

  override string toString() { result = "flask.MethodView.as_view()" }

  override predicate isSourceOf(TaintKind kind) {
    exists(MethodViewClass view_class |
      kind = view_class.asTaint() and
      this.(CallNode).getFunction().(AttrNode).getObject("as_view").pointsTo(view_class)
    )
  }
}

deprecated class FlaskCookieSet extends CookieSet, CallNode {
  FlaskCookieSet() {
    any(FlaskResponseTaintKind t).taints(this.getFunction().(AttrNode).getObject("set_cookie"))
  }

  override string toString() { result = CallNode.super.toString() }

  override ControlFlowNode getKey() { result = this.getArg(0) }

  override ControlFlowNode getValue() { result = this.getArg(1) }
}
