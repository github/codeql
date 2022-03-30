import cil
import semmle.code.csharp.commons.Disposal

from CIL::Field field
where
  mayBeDisposed(field) and
  field.getDeclaringType().getQualifiedName() = "DisposalTests.Class1"
select field.getQualifiedName()
