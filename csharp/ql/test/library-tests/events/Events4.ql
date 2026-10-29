/**
 * @name Test for events
 */

import csharp

from Event e
where
  e.getName() = "MouseUp" and
  e.getDeclaringType().hasFullyQualifiedName("Events", "Control") and
  e.getType().hasName("EventHandler") and
  e.isPublic()
select e, e.getType()
