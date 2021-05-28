import semmle.code.cil.Types

from Enum e
where e.getQualifiedName() != "Interop.Sys.LockType" // doesn't exist on osx
select e.getQualifiedName(), e.getUnderlyingType().toStringWithTypes()
