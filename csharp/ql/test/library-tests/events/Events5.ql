/**
 * @name Test for events
 */

import csharp

where
  count(Event e |
    e.getDeclaringType().hasQualifiedName("Events", "Control") and
    e.getType().hasName("EventHandler") and
    e.isPublic()
  ) = 2
select 1
