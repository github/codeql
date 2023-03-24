import javascript

query predicate test_ContextExpr(Koa::ContextNode e, Koa::RouteHandler res) {
  res = e.getRouteHandler()
}
