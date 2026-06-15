/**
 * @name Test for events
 */

import csharp

from Event e
where
  e.getName() = "MouseUp" and
  e.getDeclaringType().hasFullyQualifiedName("Events", "Control") and
  not e.isFieldLike()
select e, e.getType()
