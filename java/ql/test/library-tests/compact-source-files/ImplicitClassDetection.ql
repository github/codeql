import java

from Class c, string res
where
  exists(c.getCompilationUnit().getRelativePath()) and
  if c.isImplicit() then res = "implicit" else res = "not implicit"
select c, res
