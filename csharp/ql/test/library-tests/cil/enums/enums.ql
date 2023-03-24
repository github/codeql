import semmle.code.cil.Types
import semmle.code.csharp.commons.QualifiedName

from Enum e, string qualifier, string name
where
  e.hasQualifiedName(qualifier, name) and
  not (qualifier = "Interop.Sys" and name = "LockType") // doesn't exist on osx
select getQualifiedName(qualifier, name), e.getUnderlyingType().toStringWithTypes()
