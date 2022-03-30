import javascript

query predicate test_ResponseBody(HTTP::ResponseBody rb, Express::RouteHandler rh) {
  rb.getRouteHandler() = rh
}
