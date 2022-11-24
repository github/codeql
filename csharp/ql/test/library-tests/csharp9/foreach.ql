import csharp
import semmle.code.csharp.commons.QualifiedName

private string getLocation(Member m) {
  if m.fromSource() then result = m.getALocation().(SourceLocation).toString() else result = "-"
}

private string getIsAsync(ForeachStmt f) {
  if f.isAsync() then result = "async" else result = "sync"
}

from
  ForeachStmt f, string namespace1, string type1, string namespace2, string type2,
  string namespace3, string type3
where
  f.getGetEnumerator().getDeclaringType().hasQualifiedName(namespace1, type1) and
  f.getCurrent().getDeclaringType().hasQualifiedName(namespace2, type2) and
  f.getMoveNext().getDeclaringType().hasQualifiedName(namespace3, type3)
select f, f.getElementType().toString(), getIsAsync(f), printQualifiedName(namespace1, type1),
  getLocation(f.getGetEnumerator()), printQualifiedName(namespace2, type2),
  getLocation(f.getCurrent()), printQualifiedName(namespace3, type3), getLocation(f.getMoveNext())
