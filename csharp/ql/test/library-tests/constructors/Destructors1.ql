/**
 * @name Test for destructors
 */

import csharp

from Destructor c
where
  c.getDeclaringType().getName() = "Class" and
  c.getDeclaringType().getNamespace().getQualifiedName() = "Constructors"
select c, c.getDeclaringType().getQualifiedName()
