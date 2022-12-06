import csharp
import semmle.code.csharp.commons.QualifiedName

private string getLocation(Member m) {
  if m.fromSource() then result = m.getALocation().(SourceLocation).toString() else result = "-"
}

private string getIsAsync(ForeachStmt f) {
  if f.isAsync() then result = "async" else result = "sync"
}

from
  ForeachStmt f, string qualifier1, string type1, string qualifier2, string type2,
  string qualifier3, string type3
where
  f.getGetEnumerator().getDeclaringType().hasQualifiedName(qualifier1, type1) and
  f.getCurrent().getDeclaringType().hasQualifiedName(qualifier2, type2) and
  f.getMoveNext().getDeclaringType().hasQualifiedName(qualifier3, type3)
select f, f.getElementType().toString(), getIsAsync(f), getQualifiedName(qualifier1, type1),
  getLocation(f.getGetEnumerator()), getQualifiedName(qualifier2, type2),
  getLocation(f.getCurrent()), getQualifiedName(qualifier3, type3), getLocation(f.getMoveNext())
