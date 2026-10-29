import java

from CompilationUnit cu, Class c
where
  cu.isCompactSourceFile() and
  c.getCompilationUnit() = cu and
  c.isImplicit()
select cu, c,
  "Compact source file '" + cu.getName() + "' contains implicit class '" + c.getName() + "'"
