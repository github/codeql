import semmle.code.csharp.Printing
import semmle.code.cil.Types

from Enum e, string qualifier, string name
where
  e.hasQualifiedName(qualifier, name) and
  printQualifiedName(qualifier, name) != "Interop.Sys.LockType" // doesn't exist on osx
select printQualifiedName(qualifier, name), e.getUnderlyingType().toStringWithTypes()
