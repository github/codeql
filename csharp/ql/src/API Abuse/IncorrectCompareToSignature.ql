/**
 * @name Potentially incorrect CompareTo(...) signature
 * @description The declaring type of a method with signature `CompareTo(T)` does not implement `IComparable<T>`.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/wrong-compareto-signature
 * @tags reliability
 *       maintainability
 */

import csharp
import semmle.code.csharp.frameworks.System

predicate implementsIComparable(ValueOrRefType t, Type paramType) {
  exists(ConstructedType ct | t.getABaseType+() = ct |
    ct = any(SystemIComparableTInterface i).getAConstructedGeneric() and
    paramType = ct.getATypeArgument()
  )
  or
  t instanceof SystemIComparableTInterface
  or
  t.getABaseType*() instanceof SystemIComparableInterface and
  paramType instanceof ObjectType
}

predicate compareToMethod(Method m, Type paramType) {
  m.hasName("CompareTo") and
  m.fromSource() and
  m.isPublic() and
  m.getReturnType() instanceof IntType and
  m.getNumberOfParameters() = 1 and
  paramType = m.getAParameter().getType()
}

from Method m, RefType declaringType, Type actualParamType, string paramTypeName
where
  m.isSourceDeclaration() and
  declaringType = m.getDeclaringType() and
  compareToMethod(m, actualParamType) and
  not implementsIComparable(declaringType, actualParamType) and
  paramTypeName = actualParamType.getName()
select m,
  "The parameter of this 'CompareTo' method is of type '" + paramTypeName +
    "', but the declaring type does not implement 'IComparable<" + paramTypeName + ">'."
