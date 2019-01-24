import semmle.javascript.JSDoc

from JSDocTag jsdt, string descr, string name, string tp
where
  (if exists(jsdt.getDescription()) then descr = jsdt.getDescription() else descr = "(none)") and
  (if exists(jsdt.getName()) then name = jsdt.getName() else name = "(none)") and
  (if exists(jsdt.getType()) then tp = jsdt.getType().toString() else tp = "(none)")
select jsdt, jsdt.getTitle(), jsdt.getParent(), jsdt.getIndex(), descr, name, tp
