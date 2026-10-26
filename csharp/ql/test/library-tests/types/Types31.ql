/**
 * @name Test for type arguments to constructed types
 * @kind table
 */

import csharp

from Method m, ConstructedClass t, RefType arg1, RefType arg2
where
  m.getName() = "Map" and
  m.getReturnType() = t and
  t.getTypeArgument(0) = arg1 and
  t.getTypeArgument(1) = arg2 and
  arg1.hasFullyQualifiedName("System", "String") and
  arg2.hasFullyQualifiedName("Types", "Class")
select t, arg1.toString(), arg2
