import javascript

query predicate test_ResponseBody(Http::ResponseBody rb, Express::RouteHandler rh) {
  rb.getRouteHandler() = rh
}
