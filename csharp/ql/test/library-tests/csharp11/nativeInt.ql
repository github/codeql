import csharp

from LocalVariable v1, LocalVariable v2, Type t
where
  v1.getFile().getStem() = "NativeInt" and
  v2.getFile().getStem() = "NativeInt" and
  t = v1.getType() and
  t = v2.getType() and
  v1 != v2
select v1, v2, t.getFullyQualifiedNameDebug()
