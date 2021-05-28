import javascript

query predicate test_ResponseBody(https::ResponseBody rb, Express::RouteHandler rh) {
  rb.getRouteHandler() = rh
}
