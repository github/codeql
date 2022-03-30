import csharp

private string getLocation(Member m) {
  if m.fromSource() then result = m.getALocation().(SourceLocation).toString() else result = "-"
}

private string getIsAsync(ForeachStmt f) {
  if f.isAsync() then result = "async" else result = "sync"
}

from ForeachStmt f
select f, f.getElementType().toString(), getIsAsync(f),
  f.getGetEnumerator().getDeclaringType().getQualifiedName(), getLocation(f.getGetEnumerator()),
  f.getCurrent().getDeclaringType().getQualifiedName(), getLocation(f.getCurrent()),
  f.getMoveNext().getDeclaringType().getQualifiedName(), getLocation(f.getMoveNext())
