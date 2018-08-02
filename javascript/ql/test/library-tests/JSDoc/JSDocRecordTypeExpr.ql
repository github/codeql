import semmle.javascript.JSDoc

from JSDocRecordTypeExpr jsdrte, string name, string tp
where name = jsdrte.getAFieldName() and
      (if exists(jsdrte.getFieldTypeByName(name)) then tp = jsdrte.getFieldTypeByName(name).toString() else tp = "(none)")
select jsdrte, name, tp