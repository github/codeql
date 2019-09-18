/**
 * @name Type variable hides another type
 * @description A type variable with the same name as another type that is in scope can cause
 *              the two types to be confused.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/type-variable-hides-type
 * @tags reliability
 *       readability
 *       types
 */

import java

RefType anOuterType(TypeVariable var) {
  var.getGenericCallable().getDeclaringType() = result or
  var.getGenericType() = result or
  result = anOuterType(var).(NestedType).getEnclosingType()
}

RefType aTypeVisibleFrom(TypeVariable var) {
  result = anOuterType(var)
  or
  exists(ImportType i |
    var.getLocation().getFile() = i.getCompilationUnit() and
    result = i.getImportedType()
  )
  or
  var.getPackage() = result.getPackage() and result instanceof TopLevelType
}

from RefType hidden, TypeVariable var
where
  hidden = aTypeVisibleFrom(var) and
  var.getName() = hidden.getName()
select var, "Type $@ is hidden by this type variable.", hidden, hidden.getQualifiedName()
