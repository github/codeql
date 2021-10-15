/**
 * @name Test that there are no backing fields
 */

import csharp

from Field f
where f.fromSource()
select f.getName() as name order by name
