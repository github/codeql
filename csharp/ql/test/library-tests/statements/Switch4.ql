/**
 * @name Test the implicit switch field isn't populated.
 */

import csharp

from Field f
where f.fromSource()
select f
