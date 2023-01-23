import cil
import semmle.code.csharp.commons.Disposal
import semmle.code.csharp.commons.QualifiedName

from CIL::Field field, string qualifier, string name
where
  mayBeDisposed(field) and
  field.getDeclaringType().hasQualifiedName("DisposalTests", "Class1") and
  field.hasQualifiedName(qualifier, name)
select getQualifiedName(qualifier, name)
