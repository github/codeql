import csharp
import semmle.code.csharp.frameworks.System

from ValueOrRefType t, Method m, boolean b
where
  t.fromSource() and
  m = getInvokedEqualsMethod(t) and
  if implementsEquals(t) then b = true else b = false
select t, m.getQualifiedNameWithTypes(), b
