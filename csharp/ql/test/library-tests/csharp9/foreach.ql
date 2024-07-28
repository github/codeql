import csharp

private string getLocation(Member m) {
  if m.fromSource() then result = m.getALocation().(SourceLocation).toString() else result = "-"
}

private string getIsAsync(ForeachStmt f) {
  if f.isAsync() then result = "async" else result = "sync"
}

from ForeachStmt f
select f, f.getElementType().toString(), getIsAsync(f),
  f.getGetEnumerator().getDeclaringType().getFullyQualifiedNameDebug(),
  getLocation(f.getGetEnumerator()), f.getCurrent().getDeclaringType().getFullyQualifiedNameDebug(),
  getLocation(f.getCurrent()), f.getMoveNext().getDeclaringType().getFullyQualifiedNameDebug(),
  getLocation(f.getMoveNext())
