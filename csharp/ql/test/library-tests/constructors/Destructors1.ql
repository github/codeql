/**
 * @name Test for destructors
 */

import csharp
import semmle.code.csharp.commons.QualifiedName

from Destructor c, string qualifier, string name
where
  c.getDeclaringType().hasQualifiedName(qualifier, name) and
  qualifier = "Constructors" and
  name = "Class"
select c, c.getDeclaringType().getQualifiedName()
