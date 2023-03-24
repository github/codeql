import javascript

query predicate test_CookieMiddlewareInstance(
  Http::CookieMiddlewareInstance instance, DataFlow::Node res
) {
  res = instance.getASecretKey()
}
