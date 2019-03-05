import semmle.javascript.JSDoc

query predicate test_JSDocRecordTypeExpr(JSDocRecordTypeExpr jsdrte, string name, string tp) {
  name = jsdrte.getAFieldName() and
  (
    if exists(jsdrte.getFieldTypeByName(name))
    then tp = jsdrte.getFieldTypeByName(name).toString()
    else tp = "(none)"
  )
}
