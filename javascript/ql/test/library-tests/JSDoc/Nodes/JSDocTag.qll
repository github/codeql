import semmle.javascript.JSDoc

query predicate test_JSDocTag(
  JSDocTag jsdt, string res0, JSDoc res1, int res2, string descr, string name, string tp
) {
  (if exists(jsdt.getDescription()) then descr = jsdt.getDescription() else descr = "(none)") and
  (if exists(jsdt.getName()) then name = jsdt.getName() else name = "(none)") and
  (if exists(jsdt.getType()) then tp = jsdt.getType().toString() else tp = "(none)") and
  res0 = jsdt.getTitle() and
  res1 = jsdt.getParent() and
  res2 = jsdt.getIndex()
}
