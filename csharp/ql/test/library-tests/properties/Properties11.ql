/**
 * @name Test for properties
 */
import csharp

from Property p
where p.hasName("Y")
  and p.getDeclaringType().hasQualifiedName("Properties.B")
  and p.isReadWrite() // overrides a property that is readwrite
  and not p.isAutoImplemented()
  and p.isOverride() and p.isPublic()
select p
