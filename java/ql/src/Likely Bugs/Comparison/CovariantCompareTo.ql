/**
 * @name Overloaded compareTo
 * @description Defining 'Comparable.compareTo', where the parameter of 'compareTo' is not of the
 *              appropriate type, overloads 'compareTo' instead of overriding it.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/wrong-compareto-signature
 * @tags reliability
 *       correctness
 */

import java

private predicate implementsComparable(RefType t, RefType param) {
  exists(ParameterizedType pt |
    t.getASupertype*() = pt and
    pt.getSourceDeclaration().hasQualifiedName("java.lang", "Comparable") and
    param = pt.getATypeArgument() and
    not param instanceof Wildcard and
    not param instanceof TypeVariable
  )
}

private predicate mostSpecificComparableTypeArgument(RefType t, RefType param) {
  implementsComparable(t, param) and
  not implementsComparable(t, param.getASubtype+())
}

private predicate mostSpecificComparableTypeArgumentOrTypeObject(RefType t, RefType param) {
  if mostSpecificComparableTypeArgument(t, _)
  then mostSpecificComparableTypeArgument(t, param)
  else param instanceof TypeObject
}

private predicate compareTo(RefType declaring, Method m, RefType param) {
  m.hasName("compareTo") and
  m.isPublic() and
  m.getNumberOfParameters() = 1 and
  m.fromSource() and
  m.getAParamType() = param and
  declaring = m.getDeclaringType() and
  declaring.getASupertype*().getSourceDeclaration().hasQualifiedName("java.lang", "Comparable")
}

from Method m, Class t, Type actual, Type desired
where
  compareTo(t, m, actual) and
  mostSpecificComparableTypeArgumentOrTypeObject(t, desired) and
  actual != desired and
  not compareTo(t, _, desired) and
  not actual instanceof TypeVariable
select m,
  "The parameter of compareTo should have type '" + desired.getName() +
    "' when implementing 'Comparable<" + desired.getName() + ">'."
