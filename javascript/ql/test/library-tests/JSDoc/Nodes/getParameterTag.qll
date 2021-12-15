import javascript

query predicate test_getParameterTag(
  Parameter param, string res0, JSDocTag tag, string res1, JSDocTypeExpr res2
) {
  tag = param.getJSDocTag() and
  res0 = param.getName() and
  res1 = tag.getName() and
  res2 = tag.getType()
}
