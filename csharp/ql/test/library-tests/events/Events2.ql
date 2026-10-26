/**
 * @name Test for events
 */

import csharp

from Event e
where
  e.getName() = "Click" and
  e.getDeclaringType().hasFullyQualifiedName("Events", "Button") and
  e.isFieldLike()
select e, e.getType()
