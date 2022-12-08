import csharp
import semmle.code.csharp.commons.QualifiedName

from LocalVariable v1, LocalVariable v2, Type t, string qualifier, string name
where
  v1.getFile().getStem() = "NativeInt" and
  v2.getFile().getStem() = "NativeInt" and
  t = v1.getType() and
  t = v2.getType() and
  t.hasQualifiedName(qualifier, name) and
  v1 != v2
select v1, v2, getQualifiedName(qualifier, name)
