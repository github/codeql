import semmle.code.cil.Types
import semmle.code.csharp.commons.QualifiedName

predicate osSpecific(string qualifier, string name) {
  qualifier = "Interop.Sys" and
  (
    name = "LockType" or // doesn't exist on osx
    name = "NSSearchPathDirectory" // doesn't exist on linux.
  )
}

from Enum e, string qualifier, string name
where
  e.hasFullyQualifiedName(qualifier, name) and
  not osSpecific(qualifier, name)
select getQualifiedName(qualifier, name), e.getUnderlyingType().toStringWithTypes()
