import javascript

query predicate test_ElementDefinition_getAttributeByName(
  DOM::ElementDefinition e, string s, DOM::AttributeDefinition res
) {
  res = e.getAttributeByName(s)
}
