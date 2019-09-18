/**
 * @name Test that locations are populated for unbound generic types
 */

import csharp

from UnboundGenericType t
where type_location(t, _)
select 1
