import javascript

query predicate test_CookieMiddlewareInstance(
  https::CookieMiddlewareInstance instance, DataFlow::Node res
) {
  res = instance.getASecretKey()
}
