import javascript

query predicate test_CookieMiddlewareInstance(
  HTTP::CookieMiddlewareInstance instance, DataFlow::Node res
) {
  res = instance.getASecretKey()
}
