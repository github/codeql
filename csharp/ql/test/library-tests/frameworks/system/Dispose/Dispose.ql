import csharp
import semmle.code.csharp.commons.QualifiedName
import semmle.code.csharp.frameworks.System

from ValueOrRefType t, Method m, boolean b
where
  t.fromSource() and
  m = getInvokedDisposeMethod(t) and
  if implementsDispose(t) then b = true else b = false
select t, getFullyQualifiedNameWithTypes(m), b
