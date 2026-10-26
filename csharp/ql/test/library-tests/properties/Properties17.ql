/**
 * @name Test that there are no backing fields except for properties that use the `field` keyword in their getter or setter.
 */

import csharp

from Field f
where f.fromSource()
select f.getName() as name order by name
