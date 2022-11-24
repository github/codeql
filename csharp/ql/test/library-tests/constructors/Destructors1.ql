/**
 * @name Test for destructors
 */

import csharp
import semmle.code.csharp.commons.QualifiedName

from Destructor c, string namespace, string name
where
  c.getDeclaringType().hasQualifiedName(namespace, name) and
  namespace = "Constructors" and
  name = "Class"
select c, c.getDeclaringType().getQualifiedName()
