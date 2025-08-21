import java

from Method m, Class c, string res
where
  c = m.getDeclaringType() and
  exists(c.getCompilationUnit().getRelativePath()) and
  if c.isImplicit() then res = "in compact source" else res = "NOT in compact source"
select m, res
