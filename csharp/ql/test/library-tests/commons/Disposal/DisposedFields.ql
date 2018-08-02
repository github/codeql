import cil
import semmle.code.csharp.commons.Disposal
import Whitelist

from CIL::Field field
where mayBeDisposed(field)
  and field.getName().charAt(0) = "_" // Filter the results a little
  and not whitelistedType(field.getDeclaringType())
select field.getQualifiedName()
