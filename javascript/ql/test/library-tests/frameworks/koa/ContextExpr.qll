import javascript

query predicate test_ContextExpr(Koa::ContextExpr e, Koa::RouteHandler res) {
  res = e.getRouteHandler()
}
