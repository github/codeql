import semmle.code.cil.Types
import semmle.code.csharp.commons.QualifiedName

from Enum e, string namespace, string name
where
  e.hasQualifiedName(namespace, name) and
  not (namespace = "Interop.Sys" and name = "LockType") // doesn't exist on osx
select printQualifiedName(namespace, name), e.getUnderlyingType().toStringWithTypes()
