import cil
import semmle.code.csharp.commons.Disposal
import semmle.code.csharp.commons.QualifiedName

from CIL::Field field, string qualifier, string name
where
  mayBeDisposed(field) and
  field.getDeclaringType().hasFullyQualifiedName("DisposalTests", "Class1") and
  field.hasFullyQualifiedName(qualifier, name)
select getQualifiedName(qualifier, name)
