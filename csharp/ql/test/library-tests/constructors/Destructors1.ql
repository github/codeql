/**
 * @name Test for destructors
 */

import csharp

from Destructor c, string qualifier, string name
where
  c.getDeclaringType().hasFullyQualifiedName(qualifier, name) and
  qualifier = "Constructors" and
  name = "Class"
select c, c.getDeclaringType().getFullyQualifiedNameDebug()
