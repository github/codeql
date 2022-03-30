import javascript

query predicate test_ElementDefinition_getAttribute(
  DOM::ElementDefinition e, int i, DOM::AttributeDefinition res
) {
  res = e.getAttribute(i)
}
