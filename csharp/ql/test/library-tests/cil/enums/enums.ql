import semmle.code.cil.Types
import semmle.code.csharp.commons.QualifiedName

predicate osSpecific(string qualifier, string name) {
  qualifier = "Interop.Sys" and
  (
    name = "LockType" or // doesn't exist on osx
    name = "NSSearchPathDirectory" // doesn't exist on linux.
  )
}

deprecated query predicate enums(string qualifiedName, string type) {
  exists(Enum e, string qualifier, string name |
    e.hasFullyQualifiedName(qualifier, name) and
    not osSpecific(qualifier, name) and
    qualifiedName = getQualifiedName(qualifier, name) and
    type = e.getUnderlyingType().toStringWithTypes()
  )
}
