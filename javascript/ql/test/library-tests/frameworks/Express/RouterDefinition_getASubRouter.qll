import javascript

query predicate test_RouterDefinition_getASubRouter(
  Express::RouterDefinition r, Express::RouterDefinition res
) {
  res = r.getASubRouter()
}
